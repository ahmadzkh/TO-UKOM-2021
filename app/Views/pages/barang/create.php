<?= $this->extend('layout/template'); ?>
<?= $this->section('content'); ?>
<link rel="stylesheet" href="/assets/css/dashboard/barang/barang.css">

<div class="row no-gutters">
    <div class="col">
        <div class="card shadow-sm">
            <div class="card-header card-title fw-bold text-center">Create New Stuffs</div>
            <div class="card-body">
                <?php if (session()->getFlashdata('message')) : ?>
                <div class="row">
                    <div class="col">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <?= session()->getFlashdata('message'); ?>.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </div>
                </div>
                <?php endif; ?>
                <form action="/dashboard/stuffs/store" method="post" class="ms-auto me-auto w-75"
                    enctype="multipart/form-data">
                    <?= csrf_field(); ?>
                    <input type="text" value="<?= $id; ?>" name="id_barang" hidden>
                    <div class="mb-3">
                        <label for="nama_barang" class="mb-2">Name of Stuff</label>
                        <input type="text" id="nama_barang" name="nama_barang" autocomplete="off" autofocus
                            value="<?= old('nama_barang'); ?>"
                            class="form-control form-control-sm <?= ($validation->hasError('nama_barang')) ? 'is-invalid' : ''; ?>">
                        <?php if ($validation->hasError('nama_barang')) : ?>
                        <div class="invalid-feedback">
                            <?= $validation->getError('nama_barang'); ?>
                        </div>
                        <?php endif; ?>
                    </div>
                    <div class="mb-3">
                        <label for="spesifikasi" class="mb-2">Specification</label>
                        <textarea type="text" id="spesifikasi" name="spesifikasi" autocomplete="off" cols="30" rows="5"
                            class="form-control form-control-sm <?= ($validation->hasError('spesifikasi')) ? 'is-invalid' : ''; ?>"><?= old('spesifikasi'); ?></textarea>
                        <?php if ($validation->hasError('spesifikasi')) : ?>
                        <div class="invalid-feedback">
                            <?= $validation->getError('spesifikasi'); ?>
                        </div>
                        <?php endif; ?>
                    </div>
                    <div class="mb-3">
                        <label for="lokasi" class="mb-2">Room</label>
                        <select name="lokasi" id="lokasi"
                            class="form-control form-control-sm select custom-select custom-select-sm <?= ($validation->hasError('lokasi')) ? 'is-invalid' : ''; ?>">
                            <option value="" hidden></option>
                            <?php foreach ($lokasi as $lok) : ?>
                            <option value="<?= $lok['id_lokasi']; ?>"><?= $lok['id_lokasi']; ?></option>
                            <?php endforeach; ?>
                        </select>
                        <?php if ($validation->hasError('lokasi')) : ?>
                        <div class="invalid-feedback">
                            <?= $validation->getError('lokasi'); ?>
                        </div>
                        <?php endif; ?>
                    </div>
                    <div class="mb-3">
                        <label for="kondisi" class="mb-2">Status</label>
                        <input type="text" id="kondisi" name="kondisi" autocomplete="off" value="<?= old('kondisi'); ?>"
                            class="form-control form-control-sm <?= ($validation->hasError('kondisi')) ? 'is-invalid' : ''; ?>">
                        <?php if ($validation->hasError('kondisi')) : ?>
                        <div class="invalid-feedback">
                            <?= $validation->getError('kondisi'); ?>
                        </div>
                        <?php endif; ?>
                    </div>
                    <div class="mb-3">
                        <label for="jumlah_barang" class="mb-2">Quantity</label>
                        <input type="text" id="jumlah_barang" name="jumlah_barang" autocomplete="off"
                            value="<?= old('jumlah_barang'); ?>"
                            class="form-control form-control-sm <?= ($validation->hasError('jumlah_barang')) ? 'is-invalid' : ''; ?>">
                        <?php if ($validation->hasError('jumlah_barang')) : ?>
                        <div class="invalid-feedback">
                            <?= $validation->getError('jumlah_barang'); ?>
                        </div>
                        <?php endif; ?>
                    </div>
                    <div class="mb-3">
                        <label for="sumber" class="mb-2">Donors</label>
                        <select name="sumber" id="sumber"
                            class="form-control form-control-sm <?= ($validation->hasError('sumber')) ? 'is-invalid' : ''; ?>">
                            <option value="" hidden></option>
                            <?php foreach ($sumber as $sbr) : ?>
                            <option value="<?= $sbr['id_sumber']; ?>"><?= $sbr['id_sumber']; ?></option>
                            <?php endforeach; ?>
                        </select>
                        <?php if ($validation->hasError('sumber')) : ?>
                        <div class="invalid-feedback">
                            <?= $validation->getError('sumber'); ?>
                        </div>
                        <?php endif; ?>
                    </div>
                    <div class="mb-4">
                        <label for="gambar" class="mb-2">Picture</label>
                        <input type="file" id="gambar" name="gambar" value=""
                            class="form-control form-control-sm form-control-file <?= ($validation->hasError('gambar')) ? 'is-invalid' : ''; ?>">
                        <?php if ($validation->hasError('gambar')) : ?>
                        <div class="invalid-feedback">
                            <?= $validation->getError('gambar'); ?>
                        </div>
                        <?php endif; ?>
                    </div>
                    <div class="mb-3 text-center">
                        <button type="submit" class="btn btn-primary w-100">Submit</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<?= $this->endSection(); ?>