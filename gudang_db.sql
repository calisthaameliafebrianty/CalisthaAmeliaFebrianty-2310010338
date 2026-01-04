-- phpMyAdmin SQL Dump
-- version 6.0.0-dev+20250909.be01432c56
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 03, 2026 at 03:15 PM
-- Server version: 8.4.3
-- PHP Version: 8.4.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gudang_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `barang`
--

CREATE TABLE `barang` (
  `id_barang` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama_barang` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `stok` int NOT NULL DEFAULT '0',
  `jumlah_barang` int NOT NULL DEFAULT '0',
  `harga` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `barang`
--

INSERT INTO `barang` (`id_barang`, `nama_barang`, `stok`, `jumlah_barang`, `harga`) VALUES
('BRG001', 'Beras 5kg', 47, 47, 75000),
('BRG002', 'Gula 1kg', 64, 64, 17000),
('BRG003', 'Minyak Goreng 1L', 55, 55, 19000),
('BRG004', 'Mie Instan (1 dus)', 38, 38, 125000),
('BRG005', 'Kopi Bubuk 200g', 70, 70, 25000),
('BRG006', 'Teh Celup (50 pcs)', 55, 55, 18000),
('BRG007', 'Susu UHT 1L', 45, 45, 21000),
('BRG008', 'Tepung Terigu 1kg', 65, 65, 14000),
('BRG009', 'Telur Ayam (1 rak)', 30, 30, 58000),
('BRG010', 'Air Mineral 600ml', 96, 96, 4000);

--
-- Triggers `barang`
--
DELIMITER $$
CREATE TRIGGER `trg_barang_sync_bi` BEFORE INSERT ON `barang` FOR EACH ROW BEGIN
  IF NEW.stok IS NULL THEN
    SET NEW.stok = 0;
  END IF;
  IF NEW.jumlah_barang IS NULL THEN
    SET NEW.jumlah_barang = NEW.stok;
  END IF;

  -- If one provided and the other left at default, sync them
  IF NEW.jumlah_barang = 0 AND NEW.stok <> 0 THEN
    SET NEW.jumlah_barang = NEW.stok;
  ELSEIF NEW.stok = 0 AND NEW.jumlah_barang <> 0 THEN
    SET NEW.stok = NEW.jumlah_barang;
  END IF;

  IF NEW.harga IS NULL THEN
    SET NEW.harga = 0;
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_barang_sync_bu` BEFORE UPDATE ON `barang` FOR EACH ROW BEGIN
  -- If only stok changed, mirror to jumlah_barang
  IF (NEW.stok <> OLD.stok) AND (NEW.jumlah_barang = OLD.jumlah_barang) THEN
    SET NEW.jumlah_barang = NEW.stok;
  -- If only jumlah_barang changed, mirror to stok
  ELSEIF (NEW.jumlah_barang <> OLD.jumlah_barang) AND (NEW.stok = OLD.stok) THEN
    SET NEW.stok = NEW.jumlah_barang;
  -- If both changed, keep them aligned using stok
  ELSEIF (NEW.stok <> NEW.jumlah_barang) THEN
    SET NEW.jumlah_barang = NEW.stok;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `id_supplier` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama_supplier` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `alamat_supplier` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`id_supplier`, `nama_supplier`, `alamat_supplier`) VALUES
('SUP001', 'PT Sumber Makmur', 'Banjarmasin'),
('SUP002', 'CV Maju Jaya', 'Banjarbaru'),
('SUP003', 'UD Berkah Sejahtera', 'Martapura'),
('SUP004', 'PT Nusantara Logistik', 'Jakarta'),
('SUP005', 'CV Sentosa Abadi', 'Surabaya');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `id` bigint NOT NULL,
  `id_transaksi` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_supplier` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_barang` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jumlah` int NOT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  `tanggal` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Kode` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `supplier` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `barang` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`id`, `id_transaksi`, `id_supplier`, `id_barang`, `jumlah`, `subtotal`, `tanggal`, `Kode`, `supplier`, `barang`) VALUES
(1, 'TRX-20260103-001', 'SUP001', 'BRG003', 5, 95000.00, '2026-01-03 09:10:00', 'TRX-20260103-001', 'SUP001 - PT Sumber Makmur', 'BRG003 - Minyak Goreng 1L'),
(2, 'TRX-20260103-001', 'SUP001', 'BRG002', 10, 170000.00, '2026-01-03 09:10:00', 'TRX-20260103-001', 'SUP001 - PT Sumber Makmur', 'BRG002 - Gula 1kg'),
(3, 'TRX-20260103-002', 'SUP003', 'BRG001', 3, 225000.00, '2026-01-03 10:05:00', 'TRX-20260103-002', 'SUP003 - UD Berkah Sejahtera', 'BRG001 - Beras 5kg'),
(4, 'TRX-20260103-002', 'SUP003', 'BRG010', 24, 96000.00, '2026-01-03 10:05:00', 'TRX-20260103-002', 'SUP003 - UD Berkah Sejahtera', 'BRG010 - Air Mineral 600ml'),
(5, 'TRX-20260103-003', 'SUP002', 'BRG004', 2, 250000.00, '2026-01-03 14:20:00', 'TRX-20260103-003', 'SUP002 - CV Maju Jaya', 'BRG004 - Mie Instan (1 dus)'),
(6, 'TRX-20260103-004', 'SUP005', 'BRG002', 2, 34000.00, '2026-01-03 23:14:16', 'TRX-20260103-004', 'SUP005 - CV Sentosa Abadi', 'BRG002 - Gula 1kg'),
(7, 'TRX-20260103-004', 'SUP005', 'BRG002', 4, 68000.00, '2026-01-03 23:14:16', 'TRX-20260103-004', 'SUP005 - CV Sentosa Abadi', 'BRG002 - Gula 1kg');

--
-- Triggers `transaksi`
--
DELIMITER $$
CREATE TRIGGER `trg_transaksi_fill_bi` BEFORE INSERT ON `transaksi` FOR EACH ROW BEGIN
  DECLARE sup_nama VARCHAR(150);
  DECLARE brg_nama VARCHAR(150);

  -- keep LaporanTransaksi compatible
  IF NEW.Kode IS NULL OR NEW.Kode = '' THEN
    SET NEW.Kode = NEW.id_transaksi;
  END IF;

  -- human-readable strings for laporan (safe if lookups missing)
  IF NEW.supplier IS NULL OR NEW.supplier = '' THEN
    SET sup_nama = NULL;
    SELECT nama_supplier INTO sup_nama
    FROM supplier
    WHERE id_supplier = NEW.id_supplier
    LIMIT 1;

    IF sup_nama IS NULL THEN
      SET NEW.supplier = NEW.id_supplier;
    ELSE
      SET NEW.supplier = CONCAT(NEW.id_supplier, ' - ', sup_nama);
    END IF;
  END IF;

  IF NEW.barang IS NULL OR NEW.barang = '' THEN
    SET brg_nama = NULL;
    SELECT nama_barang INTO brg_nama
    FROM barang
    WHERE id_barang = NEW.id_barang
    LIMIT 1;

    IF brg_nama IS NULL THEN
      SET NEW.barang = NEW.id_barang;
    ELSE
      SET NEW.barang = CONCAT(NEW.id_barang, ' - ', brg_nama);
    END IF;
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_transaksi_fill_bu` BEFORE UPDATE ON `transaksi` FOR EACH ROW BEGIN
  IF NEW.Kode IS NULL OR NEW.Kode = '' THEN
    SET NEW.Kode = NEW.id_transaksi;
  END IF;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`id_barang`),
  ADD KEY `idx_barang_nama` (`nama_barang`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`id_supplier`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_transaksi_kode` (`id_transaksi`),
  ADD KEY `idx_transaksi_supplier` (`id_supplier`),
  ADD KEY `idx_transaksi_barang` (`id_barang`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `fk_transaksi_barang` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_transaksi_supplier` FOREIGN KEY (`id_supplier`) REFERENCES `supplier` (`id_supplier`) ON DELETE RESTRICT ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
