<?php

namespace App\Controllers;

use App\Controllers\BaseController;
use App\Models\BarangModel;

class BarangController extends BaseController
{
    protected $barangModel;
    
    public function __construct()
    {
        $this->barangModel = new BarangModel();
    }
    
    public function index()
    {
        $data = [
            'title' => 'UKOM | Stuffs',
            'barang' => $this->barangModel->paginate(10, 'barang'),
            'countBarang' => $this->barangModel->countAll(),
            'pager' => $this->barangModel->pager,
        ];

        // dd($data['users']);

        return view('pages/barang/index', $data);
    }
    
    public function create()
    {
        $db = \Config\Database::connect();
        $query = $db->query("SELECT newkodebarang() AS id");
        $query = $query->getResultArray();
        $id_barang = $query[0]['id'];

        $query2 = $db->query("SELECT id_lokasi FROM lokasi");
        $query2 = $query2->getResultArray();

        $query3 = $db->query("SELECT id_sumber FROM sumber_dana");
        $query3 = $query3->getResultArray();

        // dd($query2);

        $data = [
            'title' => 'UKOM | Create Stuffs',
            'id' => $id_barang,
            'lokasi' => $query2,
            'sumber' => $query3,
            'validation' => \Config\Services::validation()
        ];

        // dd($data['users']);

        return view('pages/barang/create', $data);
    }
    
    public function store()
    {
        if (!$this->validate([
            'nama_barang' => 'required|max_length[225]',
            'spesifikasi' => 'required',
            'lokasi' => 'required',
            'kondisi' => 'required|alpha',
            'jumlah_barang' => 'required|integer',
            'sumber' => 'required',
            'gambar' => 'max_size[gambar,2048]|is_image[gambar]|mime_in[gambar,image/jpg,image/jpeg,image/png]'
        ])) {
            return redirect()->to('dashboard/stuffs/create')->withInput();
        }

        $id_barang = $this->request->getPost('id_barang');
        $spesifikasi = $this->request->getPost('spesifikasi');
        $nama_barang = $this->request->getPost('nama_barang');
        $lokasi = $this->request->getPost('lokasi');
        $kondisi = $this->request->getPost('kondisi');
        $jumlah_barang = $this->request->getPost('jumlah_barang');
        $sumber = $this->request->getPost('sumber');

        $fileGambar = $this->request->getFile('gambar');

        $newStuff = $this->barangModel;
        $newStuff = $newStuff->asObject()->where('id_barang', $id_barang)->first();

        // dd($fileGambar);
        if ($fileGambar->getError() == 4) {
            $nameGambar = 'default.png';
            // dd($nameGambar);
        } else {
            $nameGambar = $id_barang . '.jpg';
            $fileGambar->move('img', $nameGambar);            
        }
        
        $this->barangModel->insert([
            'id_barang' => $id_barang,
            'nama_barang' => $nama_barang,
            'spesifikasi' => $spesifikasi,
            'lokasi' => $lokasi,
            'kondisi'=> $kondisi,
            'jumlah_barang' => $jumlah_barang,
            'sumber_dana' => $sumber,
            'gambar' => $nameGambar
        ]);

        session()->setFlashdata('message', 'New Stuff Added Successfully');
        return redirect()->to('/dashboard/stuffs');
    }
    
    public function edit($id)
    {
        $id = $id;
        $barang = $this->barangModel;
        $barang = $barang->asObject()->where('id_barang', $id)->first();

        $db = \Config\Database::connect();
        $query2 = $db->query("SELECT id_lokasi FROM lokasi");
        $query2 = $query2->getResultArray();

        $query3 = $db->query("SELECT id_sumber FROM sumber_dana");
        $query3 = $query3->getResultArray();

        $query4 = $db->query("SELECT id_supplier FROM supplier");
        $query4 = $query4->getResultArray();
        
        $data = [
            'title' => 'UKOM | Edit Stuffs',
            'barang' => $barang,
            'id' => $id,
            'lokasi' => $query2,
            'sumber' => $query3,
            'supplier' => $query4,
            'validation' => \Config\Services::validation()
        ];

        // dd($user);

        if ($barang === NULL) {
            session()->setFlashdata('missing', 'Stuff Not Found');
            return redirect()->to('/dashboard/stuff');
        }
        
        return view('pages/barang/edit', $data);
    }
    
    public function update($id)
    {
        if (!$this->validate([
            'nama_barang' => 'required|max_length[225]',
            'spesifikasi' => 'required',
            'lokasi' => 'required',
            'kondisi' => 'required|alpha',
            'jumlah_barang' => 'required|integer',
            'sumber' => 'required',
            'gambar' => 'max_size[gambar,2048]|is_image[gambar]|mime_in[gambar,image/jpg,image/jpeg,image/png]'
        ])) {
            return redirect()->to('dashboard/stuffs/edit/' . $id)->withInput();
        }

        $id_barang = $this->request->getPost('id_barang');
        $spesifikasi = $this->request->getPost('spesifikasi');
        $nama_barang = $this->request->getPost('nama_barang');
        $lokasi = $this->request->getPost('lokasi');
        $kondisi = $this->request->getPost('kondisi');
        $jumlah_barang = $this->request->getPost('jumlah_barang');
        $sumber = $this->request->getPost('sumber');
        $supplier = $this->request->getPost('supplier');

        $fileGambar = $this->request->getFile('gambar');

        if ($fileGambar->getError() == 4) {
            $nameGambar = $this->request->getPost('oldGambarName');
        } else {
            $nameGambar = $id_barang . '.jpg';
            $fileGambar->move('img', $nameGambar);
            
            if ($this->request->getPost('oldGambarName') != 'default.png') {
                unlink('img/' . $this->request->getPost('oldGambarName'));
            }
        }
        
        $this->barangModel->save([
            'id_barang' => $id_barang,
            'nama_barang' => $nama_barang,
            'spesifikasi' => $spesifikasi,
            'lokasi' => $lokasi,
            'kondisi'=> $kondisi,
            'jumlah_barang' => $jumlah_barang,
            'sumber_dana' => $sumber,
            'gambar' => $nameGambar
        ]);

        session()->setFlashdata('message', 'Stuff Changed Successfully');
        return redirect()->to('/dashboard/stuffs');
    }

    public function delete($id)
    {
        $this->barangModel->delete($id);

        session()->setFlashdata('message', 'Stuff Deleted Successfully.');
        return redirect()->to('/dashboard/stuffs');
    }
}