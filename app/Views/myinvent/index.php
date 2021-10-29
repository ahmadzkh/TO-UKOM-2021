<?= $this->extend('layout/template'); ?>
<?= $this->section('content'); ?>
<link rel="stylesheet" href="/assets/css/myinvent/index.css">

<div class="row">
    <div class="col">
        <div class="card shadow-sm">
            <div class="card-header card-title text-center">My Invent</div>
            <div class="card-body">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th scope="col">No</th>
                            <th scope="col">USERID</th>
                            <th scope="col">Date of Borrow</th>
                            <th scope="col">STUFFID</th>
                            <th scope="col">Return Date</th>
                            <?php if (session()->level === "U03") : ?>
                            <th scope="col">Handle</th>
                            <?php endif; ?>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($getInvent as $s) : ?>
                        <tr>
                            <td><?= $s->id_pinjam; ?></td>
                            <td><?= $s->peminjam; ?></td>
                            <td><?= $s->tgl_pinjam; ?></td>
                            <td><?= $s->barang_pinjam; ?></td>
                            <td><?= $s->tgl_kembali; ?></td>
                            <?php if (session()->level === "U03") : ?>
                            <td>
                                <a href="#" class="btn btn-success text-white"><i class="fas fa-trash"></i></a>
                            </td>
                            <?php endif; ?>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>

            </div>
        </div>
    </div>
</div>
<?= $this->endSection(); ?>