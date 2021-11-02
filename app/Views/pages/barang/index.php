<?= $this->extend('layout/template'); ?>
<?= $this->section('content'); ?>
<link rel="stylesheet" href="/assets/css/dashboard/barang/barang.css">

<div class="row">
    <div class="col">
        <div class="card shadow-sm">
            <div class="card-header card-title fw-bold text-center">Users</div>
            <div class="card-body">
                <?php if (session()->getFlashdata('message')) : ?>
                <div class="row p-0 m-0">
                    <div class="col p-0 m-0">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <?= session()->getFlashdata('message'); ?>.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </div>
                </div>
                <?php endif; ?>
                <?php if (session()->getFlashdata('missing')) : ?>
                <div class="row p-0 m-0">
                    <div class="col p-0 m-0">
                        <div class="alert alert-warning alert-dismissible fade show" role="alert">
                            <?= session()->getFlashdata('missing'); ?>.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </div>
                </div>
                <?php endif; ?>
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th scope="col">USER ID</th>
                            <th scope="col">Name of Stuff</th>
                            <th scope="col">Spesification</th>
                            <th scope="col">Room</th>
                            <th scope="col">Status</th>
                            <th scope="col">Stock</th>
                            <th scope="col">Donors</th>
                            <th scope="col">Handle</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($barang as $s) : ?>
                        <tr>
                            <td><?= $s['id_barang']; ?></td>
                            <td><?= $s['nama_barang']; ?></td>
                            <td style="max-width: 150px;"><?= $s['spesifikasi']; ?></td>
                            <td><?= $s['lokasi']; ?></td>
                            <td><?= $s['kondisi']; ?></td>
                            <td><?= $s['jumlah_barang']; ?></td>
                            <td><?= $s['sumber_dana']; ?></td>
                            <td>
                                <a href="/dashboard/stuffs/add-stock/<?= $s['id_barang']; ?>"
                                    class="btn btn-outline-success"><i class="fas fa-plus"></i></a>
                                <a href="/dashboard/stuffs/edit/<?= $s['id_barang']; ?>"
                                    class="btn btn-outline-warning"><i class="fas fa-edit"></i></a>
                                <form action="/dashboard/stuffs/delete/<?= $s['id_barang']; ?>" method="post"
                                    class="d-inline">
                                    <?= csrf_field(); ?>
                                    <input type="text" hidden name="_method" value="DELETE">
                                    <button type="submit" class="btn btn-outline-danger"
                                        onclick="return confirm('Are you sure?');"><i class="fas fa-trash"></i></button>
                                </form>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
                <?php if($countBarang > 10) : ?>
                <?= $pager->simpleLinks('barang', 'bootstrap'); ?>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>
<?= $this->endSection(); ?>