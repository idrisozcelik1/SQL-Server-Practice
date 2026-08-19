16. Kupon ve kampanya sistemi
Aşağıdaki tabloları tasarla:
Kuponlar
Kampanyalar
KampanyaKitaplari
SiparisKuponlari
Kuponlarda bulunması gereken bilgiler:
Kupon kodu
İndirim türü
İndirim değeri
Minimum sepet tutarı
Başlangıç ve bitiş tarihi
Kullanım limiti
Müşteri başına kullanım limiti
Aktiflik durumu

Kurallar:
İndirim türü Yüzde veya Sabit olabilir.(+)
Yüzde indirimi 0 ile 100 arasında olmalı.(+)
Kupon başlangıç tarihinden önce kullanılamamalı.(+)
Süresi dolmuş kupon kullanılamamalı.
Kullanım limiti aşılmamalı.
Sepet tutarı minimum tutarın altında kalıyorsa kupon uygulanmamalı.
İndirim, sepet toplamından büyük olamamalı.
Bir siparişe en fazla bir kupon uygulanabilmeli.

Görevler:
Kupon tablolarını oluştur.
Geçerli kuponları listeleyen bir VIEW oluştur.
Verilen kuponun kullanılabilir olup olmadığını kontrol eden sorgu yaz.
Kupon uygulanmış siparişlerin indirimsiz ve indirimli tutarını göster.
En fazla indirim sağlayan kuponu bul.
Kampanya sayesinde en fazla satılan kitapları raporla.
Hiç kullanılmamış ve süresi dolmuş kuponları getir.

-------------------------------------------------------------------------------------------------------------------------------------
--TABLOLARIN OLUŞTURULMASI

CREATE TABLE Kuponlar (
    KuponID INT IDENTITY(1,1) PRIMARY KEY,
    KuponKodu VARCHAR(50) NOT NULL UNIQUE,
    IndirimTuru VARCHAR(10) NOT NULL CHECK (IndirimTuru IN ('Yuzde', 'Sabit')),
    IndirimDegeri DECIMAL(10, 2) NOT NULL,
    MinSepetTutari DECIMAL(10, 2) NOT NULL DEFAULT 0 CHECK (MinSepetTutari >= 0),
    BaslangicTarihi DATETIME NOT NULL,
    BitisTarihi DATETIME NOT NULL,
    KullanimLimiti INT NOT NULL CHECK (KullanimLimiti > 0),
    MusteriBasinaLimit INT NOT NULL DEFAULT 1 CHECK (MusteriBasinaLimit > 0),
    AktifMi BIT NOT NULL DEFAULT 1,

    CONSTRAINT CHK_Kupon_Tarih CHECK (BitisTarihi >= BaslangicTarihi),

    CONSTRAINT CHK_Kupon_IndirimDegeri CHECK (
        (IndirimTuru = 'Yuzde' AND IndirimDegeri > 0 AND IndirimDegeri <= 100) OR
        (IndirimTuru = 'Sabit' AND IndirimDegeri > 0)
    )
);


CREATE TABLE Kampanyalar(
KampanyaID INT PRIMARY KEY IDENTITY(1,1),
KampanyaAdi VARCHAR(100) NOT NULL,
IndirimOrani DECIMAL (5,2) NOT NULL,
BaslangicTarihi DATETIME NOT NULL,
BitisTarihi DATETIME NOT NULL,
AktifMi BIT NOT NULL DEFAULT 1,

CONSTRAINT CHK_KuponTarih CHECK (BitisTarihi >= BaslangicTarihi),

 CONSTRAINT CHK_Kupon_IndirimOrani CHECK(IndirimOrani >0 AND IndirimOrani<=100)
);


CREATE TABLE KampanyaKitaplari(
KampanyaID INT FOREIGN KEY REFERENCES Kampanyalar(KampanyaID),
KitapID INT FOREIGN KEY REFERENCES Kitaplar(KitapID),

CONSTRAINT PK_KampanyaKitaplari PRIMARY KEY (KampanyaID, KitapID)
);


CREATE TABLE SiparisKuponlari(
SiparisKuponID INT PRIMARY KEY IDENTITY(1,1),
SiparisID INT UNIQUE FOREIGN KEY REFERENCES Siparisler(SiparisID),
KuponID INT FOREIGN KEY REFERENCES Kuponlar(KuponID),
KullanimTarihi DATETIME
);


------------------------------------------------------------------------------------

--TABLOLARA VERİLEN İŞLENMESİ
INSERT INTO Kuponlar (KuponKodu, IndirimTuru, IndirimDegeri, MinSepetTutari, BaslangicTarihi, BitisTarihi, KullanimLimiti, MusteriBasinaLimit, AktifMi)
VALUES 
('HOSGELDIN10', 'Yuzde', 10.00, 100.00, '2026-01-01', '2026-12-31', 500, 1, 1),
('BAHAR50',     'Sabit', 50.00, 250.00, '2026-03-01', '2026-05-31', 200, 1, 1),
('SUPERKOD25',  'Yuzde', 25.00, 300.00, '2026-06-01', '2026-08-31', 100, 2, 1),
('KITAPSEVER',  'Sabit', 30.00, 150.00, '2026-01-01', '2026-12-31', 1000, 3, 1),
('YAZFIRSATI',  'Yuzde', 15.00, 200.00, '2026-06-15', '2026-09-01', 300, 1, 1),
('VIPMUSTERI',  'Sabit', 100.00, 500.00, '2026-01-01', '2026-12-31', 50, 1, 1),
('OGRENCI20',   'Yuzde', 20.00, 120.00, '2026-02-01', '2026-11-30', 250, 2, 1),
('ESKIKUPON',   'Sabit', 20.00, 100.00, '2025-01-01', '2025-12-31', 100, 1, 0), -- Süresi bitmiş & pasif
('DEVINDIRIM',  'Yuzde', 40.00, 600.00, '2026-08-01', '2026-08-31', 50, 1, 1),
('HAFTASONU',   'Sabit', 40.00, 200.00, '2026-08-15', '2026-08-20', 150, 1, 1);


INSERT INTO Kampanyalar (KampanyaAdi, IndirimOrani, BaslangicTarihi, BitisTarihi, AktifMi)
VALUES 
('Dünya Klasikleri İndirimi',   20.00, '2026-01-01', '2026-12-31', 1),
('Yaz Okuma Şenliği',           15.00, '2026-06-01', '2026-08-31', 1),
('Bilim Kurgu Haftası',         30.00, '2026-08-10', '2026-08-25', 1),
('Tarih Kitaplarında %25',      25.00, '2026-05-01', '2026-09-30', 1),
('Felsefe & Düşünce Günleri',   10.00, '2026-02-01', '2026-12-31', 1),
('Çocuk Kitapları Festivali',   35.00, '2026-04-15', '2026-05-15', 0), -- Pasif kampanya
('Polisiye & Gerilim Rüzgarı',  18.00, '2026-07-01', '2026-09-15', 1),
('Kişisel Gelişim İndirimi',    12.00, '2026-01-01', '2026-12-31', 1),
('Akademik Yayınlar İndirimi',  22.00, '2026-08-01', '2026-10-31', 0),
('Yıl Sonu Fırsatları',         40.00, '2026-12-01', '2026-12-31', 1);


INSERT INTO KampanyaKitaplari (KampanyaID, KitapID)
VALUES 
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(4, 6),
(5, 7),
(7, 8),
(8, 9),
(9, 10);


INSERT INTO SiparisKuponlari (SiparisID, KuponID, KullanimTarihi)
VALUES 
(1, 1, '2026-02-10 14:32:00'),
(2, 2,  '2026-03-15 18:45:00'),
(3, 4,  '2026-04-01 09:20:00'),
(4, 3,  '2026-06-20 21:10:00'),
(5, 5,  '2026-07-02 11:05:00'),
(6, 6, '2026-07-18 16:40:00'),
(7, 7,   '2026-08-01 13:25:00'),
(8, 1,   '2026-08-05 19:15:00'),
(9, 10,  '2026-08-16 10:50:00'),
(14, 9, '2026-08-17 15:30:00');

SELECT * FROM Kitaplar;
SELECT * FROM Siparisler;
SELECT * FROM SiparisKuponlari;
SELECT * FROM Kuponlar;
SELECT * FROM Kampanyalar;
SELECT * FROM KampanyaKitaplari;
SELECT * FROM SiparisDetaylari;


--Geçerli kuponları listeleyen bir VIEW oluştur.
CREATE VIEW gecerli_kuponlar AS
SELECT * FROM Kuponlar WHERE AktifMi=1
GO

SELECT * FROM gecerli_kuponlar


--Verilen kuponun kullanılabilir olup olmadığını kontrol eden sorgu yaz.

--Kupon uygulanmış siparişlerin indirimsiz ve indirimli tutarını göster.
SELECT s.SiparisID as 'Sipariş ID', s.SiparisTarihi as 'Sipariş Tarihi', k.KuponKodu as 'Kupon Kodu',
    SUM(sd.Adet * sd.BirimFiyat) AS IndirimsizToplamTutar,
    sk.UygulananIndirimTutari as 'Uygulanan İndirim Tutarı',
    (SUM(sd.Adet * sd.BirimFiyat) - sk.UygulananIndirimTutari) AS IndirimliOdenecekTutar
FROM Siparisler s
INNER JOIN SiparisKuponlari sk ON s.SiparisID = sk.SiparisID
INNER JOIN Kuponlar k ON sk.KuponID = k.KuponID
INNER JOIN SiparisDetaylari sd ON s.SiparisID = sd.SiparisID
GROUP BY s.SiparisID, s.SiparisTarihi, k.KuponKodu, sk.UygulananIndirimTutari
ORDER BY s.SiparisID ASC;


ALTER TABLE SiparisKuponlari
ADD UygulananIndirimTutari DECIMAL(10, 2) NULL;


--En fazla indirim sağlayan kuponu bul.
SELECT TOP 1 k.KuponID as 'Kupon ID', k.KuponKodu as 'Kupon Kodu', SUM(sk.UygulananIndirimTutari) as 'Uygulanan İndirim'
FROM Kuponlar k 
INNER JOIN SiparisKuponlari sk ON k.KuponID=sk.KuponID
GROUP BY k.KuponID,k.KuponKodu
ORDER BY SUM(sk.UygulananIndirimTutari) DESC;


--Kampanya sayesinde en fazla satılan kitapları raporla.

SELECT k.KitapID as 'Kitap ID', k.KitapAdi as 'Kitap Adı', kam.KampanyaAdi as 'Kampanya Adı', kam.IndirimOrani as 'Kampanya İndirim Oranı',
    SUM(sd.Adet) as 'Toplam Satılan Adet',
    SUM(sd.Adet * sd.BirimFiyat) as 'Toplam Ciro'
FROM Siparisler s
INNER JOIN SiparisDetaylari sd ON s.SiparisID = sd.SiparisID
INNER JOIN KitapBaskilari kb ON sd.BaskiID = kb.BaskiID
INNER JOIN Kitaplar k ON kb.KitapID = k.KitapID
-- Kampanya ve kitap eşleştirmesi
INNER JOIN KampanyaKitaplari kk ON k.KitapID = kk.KitapID
INNER JOIN Kampanyalar kam ON kk.KampanyaID = kam.KampanyaID
-- Kural: Sipariş tarihi kampanyanın geçerlilik tarihleri arasında olmalı
WHERE s.SiparisTarihi BETWEEN kam.BaslangicTarihi AND kam.BitisTarihi
GROUP BY k.KitapID, k.KitapAdi, kam.KampanyaAdi, kam.IndirimOrani
ORDER BY SUM(sd.Adet) DESC;


--Hiç kullanılmamış ve süresi dolmuş kuponları getir.
SELECT k.KuponID as 'Kupon ID', k.KuponKodu as 'Kupon Kodu',
    k.IndirimTuru as 'İndirim Türü',
    k.IndirimDegeri as 'İndirim Değeri',
    k.BaslangicTarihi as 'Başlangıç Tarihi',
    k.BitisTarihi as 'Bitiş Tarihi'
FROM Kuponlar k
LEFT JOIN SiparisKuponlari sk ON k.KuponID = sk.KuponID
WHERE k.BitisTarihi < GETDATE()
  OR sk.KuponID IS NULL;


