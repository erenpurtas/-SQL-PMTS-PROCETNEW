-- Eğer 'eren' adında veritabanı varsa sil ve yeniden oluştur
USE master;
IF DB_ID('eren') IS NOT NULL
BEGIN
    ALTER DATABASE eren SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE eren;
END
GO

-- Yeni veritabanı 'eren' adıyla oluşturuluyor
CREATE DATABASE eren;
GO
USE eren;
GO

-- Kategoriler Tablosu (Cinsiyet, Unvan ve Yetki Bilgileri)
CREATE TABLE pmtp_Kategoriler (
    K_ID INT PRIMARY KEY IDENTITY(1,1),
    Cinsiyet NVARCHAR(10),
    Unvan NVARCHAR(50),
    Ilce_Adi NVARCHAR(50),
    Il_Adi NVARCHAR(50),
    Ulke NVARCHAR(50),
    Av_Adi NVARCHAR(50),
    Yetki_Turu NVARCHAR(50)
);
GO

-- Kullanıcılar Tablosu (Giriş bilgileri ve yetki seviyesi)
CREATE TABLE pmtp_Kullanicilar (
    Kullanici_ID INT PRIMARY KEY IDENTITY(1,1),
    Kullanici_Adi NVARCHAR(50),
    Kullanici_Sifre NVARCHAR(50),
    Yetki_ID INT,
    FOREIGN KEY (Yetki_ID) REFERENCES pmtp_Kategoriler(K_ID)
);
GO

-- Bölümler Tablosu (Departmanlar ve yöneticiler)
CREATE TABLE pmtp_Bolumler (
    Bolum_ID INT PRIMARY KEY IDENTITY(1,1),
    Bolum_Adi NVARCHAR(50),
    Yonetici_ID INT
);
GO

-- Personeller Tablosu (Çalışan bilgileri)
CREATE TABLE pmtp_Personeller (
    Pers_ID INT PRIMARY KEY IDENTITY(1,1),
    Pers_Adi NVARCHAR(50),
    Pers_Soyadi NVARCHAR(50),
    Pers_DTarhi DATE,
    Pers_Giris_Tarihi DATE,
    Pers_Cikis_Tarihi DATE,
    Pers_Adres NVARCHAR(255),
    Pers_Tel NVARCHAR(20),
    Pers_Kodu NVARCHAR(20),
    Pers_Eposta NVARCHAR(100),
        Cinsiyet_ID INT,
    Unvan_ID INT,
    Pers_Maas DECIMAL(10,2),
    Pers_Komisyon_Yuzdesi DECIMAL(5,2),
    Pers_Fotograf NVARCHAR(255),
    Pers_CV_File NVARCHAR(255),
    Pers_CV_Web NVARCHAR(255),
    Pers_Aktif_Mi BIT DEFAULT 1,
    Kaydeden_ID INT,
    Kayit_Tarihi DATE DEFAULT GETDATE(),
    Bolum_ID INT,
    FOREIGN KEY (Cinsiyet_ID) REFERENCES pmtp_Kategoriler(K_ID),
    FOREIGN KEY (Unvan_ID) REFERENCES pmtp_Kategoriler(K_ID),
    FOREIGN KEY (Bolum_ID) REFERENCES pmtp_Bolumler(Bolum_ID)
);
GO

-- Maaşlar Tablosu (Personel maaş detayları)
CREATE TABLE pmtp_Maaslar (
    Maas_ID INT PRIMARY KEY IDENTITY(1,1),
    Pers_ID INT,
    Maas_Tutari DECIMAL(10,2),
    Maas_Komisyonu DECIMAL(10,2),
    Maas_Tarihi DATE DEFAULT GETDATE(),
    Maas_Toplam AS (Maas_Tutari + Maas_Komisyonu),
    Maas_Yili AS (DATEPART(YEAR, Maas_Tarihi)),
    FOREIGN KEY (Pers_ID) REFERENCES pmtp_Personeller(Pers_ID)
);
GO

-- Hesaplama sütunu
ALTER TABLE pmtp_Personeller
ADD Pers_Isim AS (Pers_Adi + ' ' + Pers_Soyadi);
GO

-- VERİ EKLEME

-- Kategoriler
INSERT INTO pmtp_Kategoriler (Cinsiyet, Unvan, Ilce_Adi, Il_Adi, Ulke, Av_Adi, Yetki_Turu) VALUES
('Erkek', 'Yazılım Uzmanı', 'Kadıköy', 'İstanbul', 'Türkiye', 'Admin', 'Tam Yetki'),
('Kadın', 'Proje Yöneticisi', 'Beşiktaş', 'İstanbul', 'Türkiye', 'Editör', 'Orta Yetki'),
('Erkek', 'Analist', 'Ataşehir', 'İstanbul', 'Türkiye', 'Kullanıcı', 'Sınırlı Yetki'),
('Kadın', 'Destek Uzmanı', 'Üsküdar', 'İstanbul', 'Türkiye', 'Misafir', 'Görüntüleme'),
('Erkek', 'Test Uzmanı', 'Şişli', 'İstanbul', 'Türkiye', 'Admin', 'Tam Yetki');
GO

-- Kullanıcılar
INSERT INTO pmtp_Kullanicilar (Kullanici_Adi, Kullanici_Sifre, Yetki_ID) VALUES
('burakd', 'pass123', 1),
('aysec', 'pass123', 2),
('denizk', 'pass123', 3),
('hasank', 'pass123', 4),
('zeynepa', 'pass123', 5);
GO

-- Bölümler
INSERT INTO pmtp_Bolumler (Bolum_Adi, Yonetici_ID) VALUES
('Bilgi Teknolojileri', NULL),
('İnsan Kaynakları', NULL),
('Muhasebe', NULL),
('Satış', NULL),
('Destek', NULL);
GO

-- Personeller
INSERT INTO pmtp_Personeller (Pers_Adi, Pers_Soyadi, Pers_DTarhi, Pers_Giris_Tarihi, Pers_Cikis_Tarihi, Pers_Adres, Pers_Tel, Pers_Kodu, Pers_Eposta, Pers_Fotograf, Cinsiyet_ID, Unvan_ID, Pers_Maas, Pers_Komisyon_Yuzdesi, Pers_CV_File, Pers_CV_Web, Kaydeden_ID, Bolum_ID)
VALUES 
('Burak', 'Demir', '1990-01-01', '2022-05-10', NULL, 'İstanbul/Kadıköy', '05001234567', 'P001', 'burak.demir@firma.com', 'burak.jpg', 1, 1, 18000, 5, 'cv_burak.pdf', 'www.burakdemir.com', 1, 1),
('Ayşe', 'Çelik', '1993-03-14', '2023-01-15', NULL, 'İstanbul/Beşiktaş', '05007654321', 'P002', 'ayse.celik@firma.com', 'ayse.jpg', 2, 2, 22000, 10, 'cv_ayse.pdf', 'www.aysecelik.com', 2, 2),
('Deniz', 'Koç', '1988-06-20', '2021-09-01', NULL, 'İstanbul/Ataşehir', '05009876543', 'P003', 'deniz.koc@firma.com', 'deniz.jpg', 1, 3, 20000, 8, 'cv_deniz.pdf', 'www.denizkoc.com', 3, 1),
('Hasan', 'Kara', '1995-12-05', '2024-02-01', NULL, 'İstanbul/Üsküdar', '05001112233', 'P004', 'hasan.kara@firma.com', 'hasan.jpg', 2, 4, 17000, 6, 'cv_hasan.pdf', 'www.hasankara.com', 4, 5),
('Zeynep', 'Arslan', '1992-11-11', '2020-07-20', NULL, 'İstanbul/Şişli', '05009998877', 'P005', 'zeynep.arslan@firma.com', 'zeynep.jpg', 1, 5, 21000, 9, 'cv_zeynep.pdf', 'www.zeyneparslan.com', 5, 3);
GO

-- Maaşlar
INSERT INTO pmtp_Maaslar (Pers_ID, Maas_Tutari, Maas_Komisyonu, Maas_Tarihi) VALUES
(1, 18000, 900, '2024-01-01'),
(2, 22000, 2200, '2024-01-01'),
(3, 20000, 1600, '2024-01-01'),
(4, 17000, 1020, '2024-01-01'),
(5, 21000, 1890, '2024-01-01');
GO

-- Tablo içeriklerini görüntülemek için örnek sorgular
SELECT * FROM pmtp_Kategoriler;
SELECT * FROM pmtp_Kullanicilar;
SELECT * FROM pmtp_Bolumler;
SELECT * FROM pmtp_Personeller;
SELECT * FROM pmtp_Maaslar;