-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 30, 2021 at 02:08 PM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 8.0.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_inventaris_rpla_1920_02_ahmadzakyhumami`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `tambag_barangmasuk` (`barang` CHAR(8), `supplier` CHAR(6), `masuk` INT)  BEGIN
	DECLARE jml_lama int DEFAULT 0;
	DECLARE total_lama int DEFAULT 0;
	DECLARE total_baru int DEFAULT 0;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING ROLLBACK;
    START TRANSACTION;
    
		INSERT INTO barang_masuk(id_barang, tgl_masuk, jml_masuk, supplier) VALUES(barang, CURRENT_DATE(), masuk, supplier); 
    
		SELECT jml_masuk INTO jml_lama FROM stok WHERE id_barang = barang;
		SELECT total_barang INTO total_lama FROM stok WHERE id_barang = barang;
    
		UPDATE stok SET jml_masuk =jml_lama+masuk WHERE id_barang = barang;
		UPDATE stok SET total_barang = jml_masuk-jml_keluar WHERE id_barang = barang;
    
		SELECT total_barang INTO total_baru FROM stok WHERE id_barang = barang;
        UPDATE barang SET jumlah_barang = total_baru WHERE id_barang = barang;
	COMMIT;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `newkodebarang` () RETURNS CHAR(8) CHARSET utf8mb4 BEGIN
	DECLARE kode_lama CHAR(8) DEFAULT "BRG10001";
    DECLARE ambil_angka CHAR(5) DEFAULT "00000";
    DECLARE kode_baru CHAR(8) DEFAULT "BRG00000";
    SELECT MAX(id_barang) INTO kode_lama FROM barang;
    SET ambil_angka =  SUBSTR(kode_lama, 4, 5);
    SET ambil_angka = ambil_angka + 1;
    SET kode_baru = CONCAT("BRG", ambil_angka);
    RETURN kode_baru;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `newkodesupplier` () RETURNS CHAR(6) CHARSET utf8mb4 BEGIN
	DECLARE kode_lama CHAR(6) DEFAULT "SPR001";
    DECLARE null_angka int DEFAULT "000";
    DECLARE ambil_angka CHAR(3) DEFAULT "000";
    DECLARE kode_baru CHAR(6) DEFAULT "SPR000";
    SELECT MAX(id_supplier) INTO kode_lama FROM supplier;
    SET ambil_angka = SUBSTR(kode_lama, 4, 3);
    SET ambil_angka = LPAD(ambil_angka + 1, 3, 0);
    SET kode_baru = CONCAT("SPR" ,ambil_angka);
    RETURN kode_baru;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `newkodeuser` () RETURNS CHAR(8) CHARSET utf8mb4 BEGIN
	DECLARE id_lama char(8) DEFAULT "USR00001";
    DECLARE ambil_angka char(5) DEFAULT "00000";
    DECLARE id_baru char(8) DEFAULT "USR00000";
    
    SELECT MAX(id_user) INTO id_lama FROM user;
    
    SET ambil_angka = SUBSTR(id_lama, 4, 5);
    SET ambil_angka = ambil_angka + 1;
    SET id_baru = CONCAT("USR", ambil_angka);
    
    RETURN id_baru;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `barang`
--

CREATE TABLE `barang` (
  `id_barang` char(8) NOT NULL,
  `nama_barang` varchar(225) NOT NULL,
  `spesifikasi` text NOT NULL,
  `lokasi` char(4) NOT NULL,
  `kondisi` varchar(20) NOT NULL,
  `jumlah_barang` int(11) NOT NULL,
  `sumber_dana` char(4) NOT NULL,
  `gambar` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `barang`
--

INSERT INTO `barang` (`id_barang`, `nama_barang`, `spesifikasi`, `lokasi`, `kondisi`, `jumlah_barang`, `sumber_dana`, `gambar`) VALUES
('BRG10001', 'Kursi Siswa', 'Bantalan Merah\r\naluminium', 'R001', 'Baik', 36, 'S001', 'BRG10001.jpg'),
('BRG10002', 'Kursi Lipat Siswa', 'Kursi Lipat\r\nmerk informa\r\nBantalan Hitam', 'R002', 'Baik', 20, 'S001', 'BRG10002.jpg'),
('BRG20001', 'Laptop Acer Aspire E1-471', 'Acer Aspire E1-471\r\nCore i3 RAM 4GB, HDD 500GB', 'R002', 'Baik', 27, 'S002', 'BRG20001.jpg'),
('BRG20002', 'Laptop Lenovo E550', 'Laptop Lenovo E550\r\nintel Core i7, RAM 8GB HDD 1TB', 'R002', 'Baik', 23, 'S003', 'BRG20002.jpg'),
('BRG20003', 'PC Rakitan i7', 'Intel Core i7\r\nRAM 16GB\r\nSSD 512GB', 'R001', 'Baik', 12, 'S004', 'BRG20003.jpg'),
('BRG20004', 'Camera DSLR D60', 'DSLR Canon D60', 'R005', 'Baik', 16, 'S003', 'BRG20004.jpg'),
('BRG30001', 'Lighting set', 'stand light tronik 2\r\nlighting tronik2 100watt\r\nP', 'R005', 'Baik', 2, 'S005', 'BRG30001.jpg'),
('BRG30002', 'Tripod Kamera', 'Takara Tripod', 'R005', 'Baik', 4, 'S002', 'BRG30002.jpg');

--
-- Triggers `barang`
--
DELIMITER $$
CREATE TRIGGER `trigger_insert_barang_stok_ahmadzakyhumami_xiirpla` AFTER INSERT ON `barang` FOR EACH ROW BEGIN
	DECLARE jml_keluar INT DEFAULT 0;
	DECLARE total_barang INT DEFAULT 0;
	SET total_barang = NEW.jumlah_barang - jml_keluar;
	INSERT INTO stok VALUES(NEW.id_barang, NEW.jumlah_barang, jml_keluar, total_barang);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trigger_log_delete_barang_ahmadzakyhumami_xiirpla` BEFORE DELETE ON `barang` FOR EACH ROW BEGIN
	INSERT INTO barang_log VALUES(0, 'DELETE', OLD.nama_barang, OLD.spesifikasi, OLD.lokasi, OLD.kondisi, OLD.jumlah_barang, OLD.sumber_dana, NOW());
	DELETE FROM stok WHERE id_barang = OLD.id_barang;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trigger_log_insert_barang_ahmadzakyhumami_xiirpla` AFTER INSERT ON `barang` FOR EACH ROW BEGIN
	INSERT INTO barang_log VALUES(0, 'INSERT', NEW.nama_barang, NEW.spesifikasi, NEW.lokasi, NEW.kondisi, NEW.jumlah_barang, NEW.sumber_dana, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trigger_log_update_barang_ahmadzakyhumami_xiirpla` AFTER UPDATE ON `barang` FOR EACH ROW BEGIN
	INSERT INTO barang_log VALUES(0, 'UPDATE', NEW.nama_barang, NEW.spesifikasi, NEW.lokasi, NEW.kondisi, NEW.jumlah_barang, NEW.sumber_dana, NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `barang_keluar`
--

CREATE TABLE `barang_keluar` (
  `id_barang` char(8) NOT NULL,
  `tgl_keluar` date NOT NULL,
  `jml_keluar` int(11) NOT NULL,
  `supplier` varchar(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `barang_keluar`
--

INSERT INTO `barang_keluar` (`id_barang`, `tgl_keluar`, `jml_keluar`, `supplier`) VALUES
('BRG20001', '2017-11-06', 3, 'SPR005'),
('BRG10001', '2020-11-03', 16, 'SPR001');

-- --------------------------------------------------------

--
-- Table structure for table `barang_log`
--

CREATE TABLE `barang_log` (
  `id_log` int(11) NOT NULL,
  `nama_event` varchar(15) NOT NULL,
  `nama_barang` varchar(225) NOT NULL,
  `spesifikasi` text NOT NULL,
  `lokasi` char(4) NOT NULL,
  `kondisi` varchar(20) NOT NULL,
  `jumlah_barang` int(11) NOT NULL,
  `sumber_dana` char(4) NOT NULL,
  `waktu_event` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `barang_log`
--

INSERT INTO `barang_log` (`id_log`, `nama_event`, `nama_barang`, `spesifikasi`, `lokasi`, `kondisi`, `jumlah_barang`, `sumber_dana`, `waktu_event`) VALUES
(1, 'INSERT', 'Printer Sony', '16jt Colors', 'R001', 'Baik', 10, 'S003', '2021-10-28 15:09:20'),
(2, 'DELETE', 'Printer Sony', '16jt Colors', 'R001', 'Baik', 10, 'S003', '2021-10-28 15:11:36'),
(3, 'UPDATE', 'Kursi Lipat Siswa', 'Kursi Lipat\r\nmerk informa\r\nBantalan Hitam', 'R002', 'Baik', 20, 'S001', '2021-10-29 22:37:14'),
(4, 'UPDATE', 'Camera DSLR D60', 'DSLR Canon D60', 'R005', 'Baik', 16, 'S003', '2021-10-29 22:42:43'),
(5, 'UPDATE', 'Camera DSLR D60', 'DSLR Canon D60', 'R005', 'Baik', 16, 'S003', '2021-10-29 22:43:00'),
(6, 'UPDATE', 'Laptop Acer Aspire E1-471', 'Acer Aspire E1-471\r\nCore i3 RAM 4GB, HDD 500GB', 'R002', 'Baik', 27, 'S002', '2021-10-29 22:51:33'),
(7, 'UPDATE', 'Kursi Siswa', 'Bantalan Merah\r\naluminium', 'R001', 'Baik', 36, 'S001', '2021-10-29 22:51:44'),
(8, 'UPDATE', 'Laptop Lenovo E550', 'Laptop Lenovo E550\r\nintel Core i7, RAM 8GB HDD 1TB', 'R002', 'Baik', 23, 'S003', '2021-10-29 22:51:52'),
(9, 'UPDATE', 'PC Rakitan i7', 'Intel Core i7\r\nRAM 16GB\r\nSSD 512GB', 'R001', 'Baik', 12, 'S004', '2021-10-29 22:52:00'),
(10, 'UPDATE', 'PC Rakitan i7', 'Intel Core i7\r\nRAM 16GB\r\nSSD 512GB', 'R001', 'Baik', 12, 'S004', '2021-10-29 22:52:06'),
(11, 'UPDATE', 'Lighting set', 'stand light tronik 2\r\nlighting tronik2 100watt\r\nP', 'R005', 'Baik', 2, 'S005', '2021-10-29 22:52:17'),
(12, 'UPDATE', 'Tripod Kamera', 'Takara Tripod', 'R005', 'Baik', 4, 'S002', '2021-10-29 22:52:24');

-- --------------------------------------------------------

--
-- Table structure for table `barang_masuk`
--

CREATE TABLE `barang_masuk` (
  `id_barang` char(8) NOT NULL,
  `tgl_masuk` date NOT NULL,
  `jml_masuk` int(11) NOT NULL,
  `supplier` char(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `barang_masuk`
--

INSERT INTO `barang_masuk` (`id_barang`, `tgl_masuk`, `jml_masuk`, `supplier`) VALUES
('BRG10001', '2007-08-03', 36, 'SPR001'),
('BRG10002', '2007-08-01', 36, 'SPR002'),
('BRG20001', '2013-07-09', 30, 'SPR004'),
('BRG20002', '2014-03-08', 23, 'SPR003'),
('BRG20003', '2020-11-10', 12, 'SPR004'),
('BRG20004', '2014-04-13', 16, 'SPR005'),
('BRG30001', '2018-04-06', 2, 'SPR005'),
('BRG30002', '2018-04-06', 4, 'SPR005');

-- --------------------------------------------------------

--
-- Stand-in structure for view `detail_pinjam`
-- (See below for the actual view)
--
CREATE TABLE `detail_pinjam` (
`id_barang` char(8)
,`nama_barang` varchar(225)
,`lokasi` char(4)
,`jumlah_barang` int(11)
,`peminjam` char(8)
,`jml_pinjam` int(11)
,`tgl_pinjam` date
,`tgl_kembali` date
,`kondisi` varchar(225)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `jumlah_barang_dipinjam_tiap_ruang`
-- (See below for the actual view)
--
CREATE TABLE `jumlah_barang_dipinjam_tiap_ruang` (
`id_lokasi` char(4)
,`nama_lokasi` varchar(225)
,`jumlah_barang` int(11)
,`barang_dipinjam` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `jumlah_ruang`
-- (See below for the actual view)
--
CREATE TABLE `jumlah_ruang` (
`jumlah_ruang` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `jumlah_ruang_tiap_penanggungjawab`
-- (See below for the actual view)
--
CREATE TABLE `jumlah_ruang_tiap_penanggungjawab` (
`penanggung_jawab` varchar(225)
,`keterangan` text
,`jumlah_lokasi` bigint(21)
);

-- --------------------------------------------------------

--
-- Table structure for table `level_user`
--

CREATE TABLE `level_user` (
  `id_level` char(3) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `keterangan` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `level_user`
--

INSERT INTO `level_user` (`id_level`, `nama`, `keterangan`) VALUES
('U01', 'Administrator', ''),
('U02', 'Manajemen', ''),
('U03', 'Peminjam', '');

-- --------------------------------------------------------

--
-- Table structure for table `lokasi`
--

CREATE TABLE `lokasi` (
  `id_lokasi` char(4) NOT NULL,
  `nama_lokasi` varchar(225) NOT NULL,
  `penanggung_jawab` varchar(225) NOT NULL,
  `keterangan` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `lokasi`
--

INSERT INTO `lokasi` (`id_lokasi`, `nama_lokasi`, `penanggung_jawab`, `keterangan`) VALUES
('R001', 'Lab RPL 1', 'Satria Ade Putra', 'Lantai 3'),
('R002', 'Lab RPL 2', 'Satria Ade Putra', 'Lantai 3'),
('R003', 'Lab TKJ 1', 'Supriyadi', 'Lantai 2 Gedung D'),
('R004', 'Lab TKJ 2', 'Supriyadi', 'Lantai 2 Gedung D'),
('R005', 'Lab Multimedia', 'Bayu Setiawan', 'Gedung Multimedia');

-- --------------------------------------------------------

--
-- Stand-in structure for view `lokasi_barang`
-- (See below for the actual view)
--
CREATE TABLE `lokasi_barang` (
`id_barang` char(8)
,`nama_barang` varchar(225)
,`id_lokasi` char(4)
,`nama_lokasi` varchar(225)
,`penanggung_jawab` varchar(225)
,`keterangan` text
,`jumlah_barang` int(11)
,`kondisi` varchar(20)
);

-- --------------------------------------------------------

--
-- Table structure for table `pinjam_barang`
--

CREATE TABLE `pinjam_barang` (
  `id_pinjam` int(11) NOT NULL,
  `peminjam` char(8) NOT NULL,
  `tgl_pinjam` date NOT NULL,
  `barang_pinjam` char(8) NOT NULL,
  `jml_pinjam` int(11) NOT NULL,
  `tgl_kembali` date NOT NULL,
  `kondisi` varchar(225) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `pinjam_barang`
--

INSERT INTO `pinjam_barang` (`id_pinjam`, `peminjam`, `tgl_pinjam`, `barang_pinjam`, `jml_pinjam`, `tgl_kembali`, `kondisi`) VALUES
(1, 'USR20001', '2021-06-09', 'BRG20002', 1, '2021-06-23', 'Baik'),
(2, 'USR20002', '2021-06-09', 'BRG20002', 1, '2021-06-09', 'Baik'),
(3, 'USR20004', '2021-08-05', 'BRG20004', 3, '2021-08-21', 'Baik'),
(4, 'USR20004', '2021-08-05', 'BRG30002', 3, '2021-08-05', 'Baik');

-- --------------------------------------------------------

--
-- Stand-in structure for view `ratarata_barang`
-- (See below for the actual view)
--
CREATE TABLE `ratarata_barang` (
`ratarata_barang` decimal(14,4)
);

-- --------------------------------------------------------

--
-- Table structure for table `stok`
--

CREATE TABLE `stok` (
  `id_barang` char(8) NOT NULL,
  `jml_masuk` int(11) NOT NULL,
  `jml_keluar` int(11) NOT NULL,
  `total_barang` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `stok`
--

INSERT INTO `stok` (`id_barang`, `jml_masuk`, `jml_keluar`, `total_barang`) VALUES
('BRG10001', 36, 0, 36),
('BRG10002', 36, 16, 20),
('BRG20001', 30, 3, 27),
('BRG20002', 23, 0, 23),
('BRG20003', 12, 0, 12),
('BRG20004', 16, 0, 16),
('BRG30001', 2, 0, 2),
('BRG30002', 4, 0, 4);

-- --------------------------------------------------------

--
-- Stand-in structure for view `stok_barang`
-- (See below for the actual view)
--
CREATE TABLE `stok_barang` (
`id_barang` char(8)
,`nama_barang` varchar(225)
,`jml_masuk` int(11)
,`jml_keluar` int(11)
,`jumlah_barang` int(11)
,`lokasi` char(4)
,`kondisi` varchar(20)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `stok_terendah`
-- (See below for the actual view)
--
CREATE TABLE `stok_terendah` (
`stok_terendah` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `stok_tertinggi`
-- (See below for the actual view)
--
CREATE TABLE `stok_tertinggi` (
`stok_tertinggi` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `sumber_barang`
-- (See below for the actual view)
--
CREATE TABLE `sumber_barang` (
`id_barang` char(8)
,`nama_barang` varchar(225)
,`lokasi` char(4)
,`kondisi` varchar(20)
,`sumber_dana` char(4)
,`keterangan` text
);

-- --------------------------------------------------------

--
-- Table structure for table `sumber_dana`
--

CREATE TABLE `sumber_dana` (
  `id_sumber` char(4) NOT NULL,
  `nama_sumber` varchar(225) NOT NULL,
  `keterangan` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `sumber_dana`
--

INSERT INTO `sumber_dana` (`id_sumber`, `nama_sumber`, `keterangan`) VALUES
('S001', 'Komite 07/09', 'Bantuan Komite 2007/2009'),
('S002', 'Komite 13', 'Bantuan Komite 2013'),
('S003', 'Sed t-vet', 'Bantuan Kerja sama Indonesia Jerman'),
('S004', 'BOPD 2020', 'Bantuan Provinsi Jawa Barat 2020'),
('S005', 'BOSDA 2018', 'Bantuan Operasional Sekolah Daeraj Jawa Barat 2018');

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `id_supplier` varchar(8) NOT NULL,
  `nama_supplier` varchar(225) NOT NULL,
  `alamat_supplier` text NOT NULL,
  `telp_supplier` varchar(14) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`id_supplier`, `nama_supplier`, `alamat_supplier`, `telp_supplier`) VALUES
('SPR001', 'INFORMA - MALL METROPOLITAN BEKASI', 'Mal Metropolitan, Jl. KH. Noer Ali No.1, RT.008/RW.002, Pekayon Jaya, Kec. Bekasi Sel., Kota Bks, Jawa Barat 17148', '0812-9604-6051'),
('SPR002', 'Mitrakantor.com', 'Alamat: Jl. I Gusti Ngurah Rai No.20, RT.1/RW.10, Klender, Kec. Duren Sawit, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13470', '(021) 22862086'),
('SPR003', 'bhinneka.com', 'Jl. Gn. Sahari No.73C, RT.9/RW.7, Gn. Sahari Sel., Kec. Kemayoran, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10610', '(021) 29292828'),
('SPR004', 'World Computer', 'Harco Mangga Dua Plaza B3/1, Jalan Arteri Mangga Dua Raya, RT.17/RW.11, Mangga Dua Sel., Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10730', '(021) 6125266'),
('SPR005', 'Anekafoto Metro Atom', 'Metro Atom Plaza Jalan Samanhudi Blok AKS No. 19, RT.20/RW.3, Ps. Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710', '(021) 3455544');

-- --------------------------------------------------------

--
-- Stand-in structure for view `supplier_barang_keluar`
-- (See below for the actual view)
--
CREATE TABLE `supplier_barang_keluar` (
`id_barang` char(8)
,`nama_barang` varchar(225)
,`tgl_keluar` date
,`jml_keluar` int(11)
,`supplier` varchar(8)
,`nama_supplier` varchar(225)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `supplier_barang_masuk`
-- (See below for the actual view)
--
CREATE TABLE `supplier_barang_masuk` (
`id_barang` char(8)
,`nama_barang` varchar(225)
,`tgl_masuk` date
,`jml_masuk` int(11)
,`supplier` char(8)
,`nama_supplier` varchar(225)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `total_jumlah_barang`
-- (See below for the actual view)
--
CREATE TABLE `total_jumlah_barang` (
`total_jumlah_barang` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id_user` char(8) NOT NULL,
  `nama` varchar(225) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` text NOT NULL,
  `level` char(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id_user`, `nama`, `username`, `password`, `level`) VALUES
('USR00001', 'Nana Sukmana', 'admin', '$2y$10$bTRGa.4gZeDz5gBNwFPVge/0qzJZ2jCAw9dy9ldmkXijTzmwOUwGO', 'U01'),
('USR00002', 'Deden Deendi', 'toolman=RPL', '$2y$10$Ll/vR7VG18lFOuYdSMrLxubqpxOlOodyV80xooW1E16pateIqlUoC', 'U02'),
('USR00003', 'Ilham Kamil', 'toolman=MM', '$2y$10$9F4twIL7kjNETvI4dvEfn.e3wjasrtYQBTfWHzkPPjlUSL9t5A41.', 'U02'),
('USR00004', 'Abdul Rahman', 'toolman=TKJ', '$2y$10$DSEarvRsY.Rp3mjEMyvPcOIx6ZmxjRZYa/UR5Uy5.rgoz4H20tz7S', 'U02'),
('USR20001', 'Dzaki', 'dzaki', '$2y$10$UtYefixh0/.ZexAf4OckE.W46LrgzpBDh8M1BbrqMPy6BONmbWRRC', 'U03'),
('USR20002', 'Sulthan', 'sulthan', '$2y$10$2T47MaDwTYvFVLSxpT0ToenKKSAOp/WGukrSTse/eu2FPZFrDNpVy', 'U03'),
('USR20003', 'Fahru', 'fahru', '$2y$10$SCUHvr1giulY5Y.mLFh/q.N6aPUZ9T7KUptG1oyjeGbg9i4UpITzm', 'U03'),
('USR20004', 'Akwan', 'akwan', '$2y$10$jt7OKUzPwfYM./EuEjhIYeAW/GXFhdUUCTwQXyUWnq9cwAERWMzo2', 'U03');

-- --------------------------------------------------------

--
-- Structure for view `detail_pinjam`
--
DROP TABLE IF EXISTS `detail_pinjam`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `detail_pinjam`  AS SELECT `barang`.`id_barang` AS `id_barang`, `barang`.`nama_barang` AS `nama_barang`, `barang`.`lokasi` AS `lokasi`, `barang`.`jumlah_barang` AS `jumlah_barang`, `pinjam_barang`.`peminjam` AS `peminjam`, `pinjam_barang`.`jml_pinjam` AS `jml_pinjam`, `pinjam_barang`.`tgl_pinjam` AS `tgl_pinjam`, `pinjam_barang`.`tgl_kembali` AS `tgl_kembali`, `pinjam_barang`.`kondisi` AS `kondisi` FROM (`pinjam_barang` left join `barang` on(`barang`.`id_barang` = `pinjam_barang`.`barang_pinjam`)) ;

-- --------------------------------------------------------

--
-- Structure for view `jumlah_barang_dipinjam_tiap_ruang`
--
DROP TABLE IF EXISTS `jumlah_barang_dipinjam_tiap_ruang`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `jumlah_barang_dipinjam_tiap_ruang`  AS SELECT `lokasi`.`id_lokasi` AS `id_lokasi`, `lokasi`.`nama_lokasi` AS `nama_lokasi`, `barang`.`jumlah_barang` AS `jumlah_barang`, count(`pinjam_barang`.`jml_pinjam`) AS `barang_dipinjam` FROM ((`barang` join `lokasi` on(`barang`.`lokasi` = `lokasi`.`id_lokasi`)) join `pinjam_barang` on(`barang`.`id_barang` = `pinjam_barang`.`barang_pinjam`)) GROUP BY `lokasi`.`id_lokasi` HAVING `barang_dipinjam` > 1 ;

-- --------------------------------------------------------

--
-- Structure for view `jumlah_ruang`
--
DROP TABLE IF EXISTS `jumlah_ruang`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `jumlah_ruang`  AS SELECT count(`lokasi`.`id_lokasi`) AS `jumlah_ruang` FROM `lokasi` ;

-- --------------------------------------------------------

--
-- Structure for view `jumlah_ruang_tiap_penanggungjawab`
--
DROP TABLE IF EXISTS `jumlah_ruang_tiap_penanggungjawab`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `jumlah_ruang_tiap_penanggungjawab`  AS SELECT `lokasi`.`penanggung_jawab` AS `penanggung_jawab`, `lokasi`.`keterangan` AS `keterangan`, count(`lokasi`.`nama_lokasi`) AS `jumlah_lokasi` FROM `lokasi` GROUP BY `lokasi`.`penanggung_jawab` ;

-- --------------------------------------------------------

--
-- Structure for view `lokasi_barang`
--
DROP TABLE IF EXISTS `lokasi_barang`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `lokasi_barang`  AS SELECT `barang`.`id_barang` AS `id_barang`, `barang`.`nama_barang` AS `nama_barang`, `lokasi`.`id_lokasi` AS `id_lokasi`, `lokasi`.`nama_lokasi` AS `nama_lokasi`, `lokasi`.`penanggung_jawab` AS `penanggung_jawab`, `lokasi`.`keterangan` AS `keterangan`, `barang`.`jumlah_barang` AS `jumlah_barang`, `barang`.`kondisi` AS `kondisi` FROM (`barang` left join `lokasi` on(`lokasi`.`id_lokasi` = `barang`.`lokasi`)) ;

-- --------------------------------------------------------

--
-- Structure for view `ratarata_barang`
--
DROP TABLE IF EXISTS `ratarata_barang`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ratarata_barang`  AS SELECT avg(`stok`.`total_barang`) AS `ratarata_barang` FROM `stok` ;

-- --------------------------------------------------------

--
-- Structure for view `stok_barang`
--
DROP TABLE IF EXISTS `stok_barang`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `stok_barang`  AS SELECT `stok`.`id_barang` AS `id_barang`, `barang`.`nama_barang` AS `nama_barang`, `stok`.`jml_masuk` AS `jml_masuk`, `stok`.`jml_keluar` AS `jml_keluar`, `barang`.`jumlah_barang` AS `jumlah_barang`, `barang`.`lokasi` AS `lokasi`, `barang`.`kondisi` AS `kondisi` FROM (`stok` left join `barang` on(`stok`.`id_barang` = `barang`.`id_barang`)) ;

-- --------------------------------------------------------

--
-- Structure for view `stok_terendah`
--
DROP TABLE IF EXISTS `stok_terendah`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `stok_terendah`  AS SELECT min(`stok`.`total_barang`) AS `stok_terendah` FROM `stok` ;

-- --------------------------------------------------------

--
-- Structure for view `stok_tertinggi`
--
DROP TABLE IF EXISTS `stok_tertinggi`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `stok_tertinggi`  AS SELECT max(`stok`.`total_barang`) AS `stok_tertinggi` FROM `stok` ;

-- --------------------------------------------------------

--
-- Structure for view `sumber_barang`
--
DROP TABLE IF EXISTS `sumber_barang`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sumber_barang`  AS SELECT `barang`.`id_barang` AS `id_barang`, `barang`.`nama_barang` AS `nama_barang`, `barang`.`lokasi` AS `lokasi`, `barang`.`kondisi` AS `kondisi`, `barang`.`sumber_dana` AS `sumber_dana`, `sumber_dana`.`keterangan` AS `keterangan` FROM (`barang` left join `sumber_dana` on(`barang`.`sumber_dana` = `sumber_dana`.`id_sumber`)) ;

-- --------------------------------------------------------

--
-- Structure for view `supplier_barang_keluar`
--
DROP TABLE IF EXISTS `supplier_barang_keluar`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `supplier_barang_keluar`  AS SELECT `barang`.`id_barang` AS `id_barang`, `barang`.`nama_barang` AS `nama_barang`, `barang_keluar`.`tgl_keluar` AS `tgl_keluar`, `barang_keluar`.`jml_keluar` AS `jml_keluar`, `barang_keluar`.`supplier` AS `supplier`, `supplier`.`nama_supplier` AS `nama_supplier` FROM ((`barang` join `barang_keluar` on(`barang`.`id_barang` = `barang_keluar`.`id_barang`)) join `supplier` on(`barang_keluar`.`supplier` = `supplier`.`id_supplier`)) ;

-- --------------------------------------------------------

--
-- Structure for view `supplier_barang_masuk`
--
DROP TABLE IF EXISTS `supplier_barang_masuk`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `supplier_barang_masuk`  AS SELECT `barang`.`id_barang` AS `id_barang`, `barang`.`nama_barang` AS `nama_barang`, `barang_masuk`.`tgl_masuk` AS `tgl_masuk`, `barang_masuk`.`jml_masuk` AS `jml_masuk`, `barang_masuk`.`supplier` AS `supplier`, `supplier`.`nama_supplier` AS `nama_supplier` FROM ((`barang` join `barang_masuk` on(`barang`.`id_barang` = `barang_masuk`.`id_barang`)) join `supplier` on(`barang_masuk`.`supplier` = `supplier`.`id_supplier`)) ;

-- --------------------------------------------------------

--
-- Structure for view `total_jumlah_barang`
--
DROP TABLE IF EXISTS `total_jumlah_barang`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `total_jumlah_barang`  AS SELECT sum(`barang`.`jumlah_barang`) AS `total_jumlah_barang` FROM `barang` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`id_barang`),
  ADD KEY `lokasi` (`lokasi`),
  ADD KEY `sumber_dana` (`sumber_dana`);

--
-- Indexes for table `barang_keluar`
--
ALTER TABLE `barang_keluar`
  ADD KEY `supplier` (`supplier`),
  ADD KEY `id_barang` (`id_barang`);

--
-- Indexes for table `barang_log`
--
ALTER TABLE `barang_log`
  ADD PRIMARY KEY (`id_log`);

--
-- Indexes for table `barang_masuk`
--
ALTER TABLE `barang_masuk`
  ADD KEY `id_barang` (`id_barang`),
  ADD KEY `supplier` (`supplier`);

--
-- Indexes for table `level_user`
--
ALTER TABLE `level_user`
  ADD PRIMARY KEY (`id_level`);

--
-- Indexes for table `lokasi`
--
ALTER TABLE `lokasi`
  ADD PRIMARY KEY (`id_lokasi`);

--
-- Indexes for table `pinjam_barang`
--
ALTER TABLE `pinjam_barang`
  ADD PRIMARY KEY (`id_pinjam`),
  ADD KEY `peminjam` (`peminjam`),
  ADD KEY `barang_pinjam` (`barang_pinjam`);

--
-- Indexes for table `stok`
--
ALTER TABLE `stok`
  ADD PRIMARY KEY (`id_barang`);

--
-- Indexes for table `sumber_dana`
--
ALTER TABLE `sumber_dana`
  ADD PRIMARY KEY (`id_sumber`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`id_supplier`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`),
  ADD KEY `level` (`level`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `barang_log`
--
ALTER TABLE `barang_log`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `barang`
--
ALTER TABLE `barang`
  ADD CONSTRAINT `barang_ibfk_1` FOREIGN KEY (`lokasi`) REFERENCES `lokasi` (`id_lokasi`),
  ADD CONSTRAINT `barang_ibfk_2` FOREIGN KEY (`sumber_dana`) REFERENCES `sumber_dana` (`id_sumber`);

--
-- Constraints for table `barang_keluar`
--
ALTER TABLE `barang_keluar`
  ADD CONSTRAINT `barang_keluar_ibfk_1` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`),
  ADD CONSTRAINT `barang_keluar_ibfk_2` FOREIGN KEY (`supplier`) REFERENCES `supplier` (`id_supplier`);

--
-- Constraints for table `barang_masuk`
--
ALTER TABLE `barang_masuk`
  ADD CONSTRAINT `barang_masuk_ibfk_1` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`),
  ADD CONSTRAINT `barang_masuk_ibfk_2` FOREIGN KEY (`supplier`) REFERENCES `supplier` (`id_supplier`);

--
-- Constraints for table `pinjam_barang`
--
ALTER TABLE `pinjam_barang`
  ADD CONSTRAINT `pinjam_barang_ibfk_1` FOREIGN KEY (`peminjam`) REFERENCES `user` (`id_user`),
  ADD CONSTRAINT `pinjam_barang_ibfk_2` FOREIGN KEY (`barang_pinjam`) REFERENCES `barang` (`id_barang`);

--
-- Constraints for table `stok`
--
ALTER TABLE `stok`
  ADD CONSTRAINT `stok_ibfk_1` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`);

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`level`) REFERENCES `level_user` (`id_level`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
