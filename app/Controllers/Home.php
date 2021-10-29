<?php

namespace App\Controllers;

use App\Models\UserModel;
use App\Models\BarangModel;
use App\Models\StokModel;
use App\Models\PinjamModel;
use App\Models\SumberModel;
use App\Models\SupplierModel;

class Home extends BaseController
{
    protected $barangModel;
    protected $userModel;
    protected $stokModel;
    protected $inventModel;
    protected $sourceModel;

    public function __construct()
    {
        $this->barangModel = new BarangModel();
        $this->userModel = new UserModel();
        $this->stokModel = new StokModel();
        $this->inventModel = new PinjamModel();
        $this->sourceModel = new SumberModel();
        $this->supplierModel = new SupplierModel();
    }
    
    public function index()
    {
        $id = session()->id_user;

        // dd(session()->id_user);
        
        $data = [
            'title' => 'UKOM | Dashboard',
            'user' => $this->userModel->asObject()->getUser(),
            'countStok' => $this->stokModel->asObject()->countStok(),
            'countBarang' => $this->barangModel->asObject()->countAll(),
            'getBarang' => $this->barangModel->asObject()->findAll(),
            'countInvent' => $this->inventModel->asObject()->countInvent(),
            'countSource' => $this->sourceModel->asObject()->countAll(),
            'countSupplier' => $this->supplierModel->asObject()->countAll(),
            // 'getSource' => $this->sourceModel->asObject()->findAll(),
            // 'getSupplier' => $this->supplierModel->asObject()->findAll(),
        ];
        
        // dd($source);
        return view('dashboard/index', $data);
    }

    public function myinvent()
    {
        $id = session()->id_user;

        // dd(session()->id_user);
        
        $data = [
            'title' => 'UKOM | My Invent',
            'countInvent' => $this->inventModel->asObject()->countInvent(),
            'getInvent' => $this->inventModel->asObject()->findAll(),
        ];
        
        // dd($source);
        return view('myinvent/index', $data);
    }
}