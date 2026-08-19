15. Yayınevi, baskı ve fiziksel ürün modeli
Bir kitabın farklı yayınevlerinden, farklı yıllarda ve farklı formatlarda basılabileceğini düşün.
Şu tabloları tasarla:
Yayinevleri (+)
KitapBaskilari(+)
Bir baskıda en az şu bilgiler bulunmalı:
ISBN
KitapID
YayineviID
Baskı numarası
Yayın yılı
Sayfa sayısı
Dil
FormatTuru
Güncel fiyat
Stok miktarı

Kurallar:
ISBN benzersiz olmalı. (+)
FormatTuru yalnızca Ciltli, Karton Kapak veya E-Kitap olabilir. (+)
E-kitabın stok miktarı tutulmamalı veya stok kontrolünden muaf olmalı. (+)
Fiyat sıfırdan büyük olmalı. (+)
Baskı numarası sıfırdan büyük olmalı. (+)

Görevler:
Mevcut fiyat ve stok bilgilerini Kitaplar tablosundan KitapBaskilari tablosuna taşı. (+)
Sipariş detaylarını KitapID yerine belirli bir baskıya bağla. (+)
Aynı kitabın farklı baskılarını listele. (+)
Bir kitabın en güncel baskısını bul. (+)
Yayınevlerinin bastığı benzersiz kitap sayılarını göster. (+)
Ortalama baskı fiyatı en yüksek yayınevini bul. (+)
Birden fazla yayınevi tarafından basılan kitapları listele.

--YAYINEVLERİ TABLOSUNUN OLUŞTURULMASI
CREATE TABLE Yayinevleri(
YayineviID INT PRIMARY KEY IDENTITY(1,1),
YayineviAdi VARCHAR(100)
);

--KİTAP BASKILARI TABLOSUNUN OLUŞTURULMASI
CREATE TABLE KitapBaskilari(
BaskiID INT PRIMARY KEY IDENTITY(1,1),
KitapID INT NOT NULL FOREIGN KEY REFERENCES Kitaplar(KitapID),
YayineviID INT NOT NULL FOREIGN KEY REFERENCES Yayinevleri(YayineviID),
ISBN VARCHAR(20) UNIQUE,
BaskiNumarasi INT NOT NULL CHECK(BaskiNumarasi>0),
YayinYili INT NOT NULL,
SayfaSayisi INT NOT NULL CHECK(SayfaSayisi>0),
Dil VARCHAR(20),
Fiyat DECIMAL(10, 2) NOT NULL CHECK (Fiyat > 0),
StokMiktari INT NULL,
FormatTuru VARCHAR(20) NOT NULL CHECK (FormatTuru IN ('Ciltli', 'Karton Kapak', 'E-Kitap')),
CHECK (
    (FormatTuru = 'E-Kitap' AND StokMiktari IS NULL)
    OR
    (FormatTuru <> 'E-Kitap' AND StokMiktari IS NOT NULL AND StokMiktari >= 0))
);


SELECT * FROM Yayinevleri;
SELECT * FROM KitapBaskilari;
SELECT * FROM Kitaplar;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Siparisler;

--YAYINEVLERİ TABLOSUNA DEĞER EKLEYELİM.
INSERT INTO Yayinevleri(YayineviAdi) VALUES ('Can Yayınları');
INSERT INTO Yayinevleri(YayineviAdi) VALUES ('Timaş Yayınları');
INSERT INTO Yayinevleri(YayineviAdi) VALUES ('İletişim Yayınları');
INSERT INTO Yayinevleri(YayineviAdi) VALUES ('Everest Yayınları');

--BİRKAÇ FARKLI BASKI TÜRÜNDE HAZIR ELİMİZDE OLAN KİTAPLARIN FARKLI TÜRLERİNİ EKLEYELİM.
INSERT INTO KitapBaskilari (KitapID,YayineviID,ISBN,BaskiNumarasi,YayinYili,SayfaSayisi,Dil,Fiyat,StokMiktari,FormatTuru)
VALUES(3,4,'978-605-000-20',2,2026,250,'İngilizce',250.0,150,'Ciltli');

INSERT INTO KitapBaskilari (KitapID,YayineviID,ISBN,BaskiNumarasi,YayinYili,SayfaSayisi,Dil,Fiyat,StokMiktari,FormatTuru)
VALUES(3,2,'978-605-000-21',2,2021,250,'Rusça',340.0,NULL,'E-Kitap'),

      (5,4,'978-605-000-22',2,2026,250,'İngilizce',250.0,150,'Ciltli'),
      (5,3,'978-605-000-23',3,2025,240,'İngilizce',100.0,NULL,'E-Kitap'),

      (12,2,'978-605-000-24',2,2026,250,'İngilizce',100.0,150,'Ciltli'),
      (12,3,'978-605-000-25',3,2025,250,'Türkçe',450.0,150,'Karton Kapak'),
      (12,4,'978-605-000-26',4,2022,250,'Almanca',50.0,NULL,'E-Kitap'),

      (17,4,'978-605-000-27',2,1967,250,'İngilizce',250.0,150,'Ciltli'),
      (17,4,'978-605-000-28',3,2000,250,'İngilizce',250.0,150,'Karton Kapak'),

      (6,2,'978-605-000-29',2,2026,250,'İngilizce',210.0,150,'Ciltli'),
      (6,2,'978-605-000-30',3,2022,250,'İngilizce',230.0,NULL,'E-Kitap'),
      (6,3,'978-605-000-31',4,2021,250,'Almanca',260.0,120,'Ciltli'),
      (6,4,'978-605-000-32',5,2018,250,'Rusça',245.0,100,'Ciltli');


ALTER TABLE Kitaplar
DROP COLUMN YayinTarihi;






--FİYAT VE STOK BİLGİSİNİ Kitaplar TABLOSUNDAN KitapBaskıları TABLOSUNA TAŞIMA

INSERT INTO KitapBaskilari (
    KitapID, 
    YayineviID, 
    ISBN, 
    BaskiNumarasi, 
    YayinYili, 
    SayfaSayisi, 
    Dil, 
    FormatTuru, 
    Fiyat, 
    StokMiktari
)
SELECT 
    k.KitapID,
    1 AS YayineviID,                                   -- Varsayılan olarak 1 ID'li Yayınevi (Yayinevleri tablanda olan geçerli bir ID yaz)
    CONCAT('978-605-000-', k.KitapID) AS ISBN,         -- UNIQUE kısıtlamasına takılmaması için KitapID tabanlı benzersiz geçici ISBN
    1 AS BaskiNumarasi,                                -- 1. Baskı
    2024 AS YayinYili,                                 -- Geçici Yayın Yılı
    200 AS SayfaSayisi,                                -- Geçici Sayfa Sayısı
    'Türkçe' AS Dil,                                   -- Geçici Dil
    'Karton Kapak' AS FormatTuru,                      -- CHECK kısıtlamana uygun geçici format
    k.Fiyat AS Fiyat,                                  -- Kitaplar tablosundaki ilgili KitapID'nin KENDİ fiyatı
    k.Stok AS StokMiktari                              -- Kitaplar tablosundaki ilgili KitapID'nin KENDİ stoğu
FROM Kitaplar k;


--Sipariş detaylarını KitapID yerine belirli bir baskıya bağla.
ALTER TABLE SiparisDetaylari
ADD BaskiID INT NULL FOREIGN KEY REFERENCES KitapBaskilari(BaskiID);

UPDATE sd
SET sd.BaskiID = kb.BaskiID
FROM SiparisDetaylari sd
INNER JOIN KitapBaskilari kb ON sd.KitapID = kb.KitapID;

ALTER TABLE SiparisDetaylari
ALTER COLUMN BaskiID INT NOT NULL;

-- 1. Önce KitapID üzerindeki eski Foreign Key kısıtlamasını kaldır
ALTER TABLE SiparisDetaylari
DROP CONSTRAINT FK_SiparisDetaylari_Kitaplar; -- (Sende kısıtlama adı neyse onu yaz)

-- 2. Eski KitapID sütununu sil
ALTER TABLE SiparisDetaylari
DROP COLUMN KitapID;


-- ***FOREIGN KEY TANIMLAMASI YAPARKEN İSİMLENDİRME YAPMADIĞIM İÇİN YANİ CONSTRAİNT İLE YAZMADIĞIMDAN SİSTEM OTOMATİK İSİM VERİYOR, BU KOD İLE O İSİM ÖĞRENİYORUZ.
SELECT name 
FROM sys.foreign_keys 
WHERE parent_object_id = OBJECT_ID('SiparisDetaylari');


--Aynı kitabın farklı baskılarını listele.
SELECT * FROM KitapBaskilari
WHERE KitapID IN
(
    SELECT KitapID
    FROM KitapBaskilari
    GROUP BY KitapID
    HAVING COUNT(*) > 1
)
ORDER BY KitapID, BaskiNumarasi;

------------------------------------------------------------------------------------------------
SELECT * FROM Yayinevleri;
SELECT * FROM KitapBaskilari;
SELECT * FROM Kitaplar;
SELECT * FROM SiparisDetaylari;
------------------------------------------------------------------------------------------------

--Bir kitabın en güncel baskısını bul. 
SELECT KitapID, MIN(YayinYili) as 'Yayın Yılı'
FROM KitapBaskilari
GROUP BY KitapID;


--Yayınevlerinin bastığı benzersiz kitap sayılarını göster.
SELECT yay.YayineviID,
    COUNT(DISTINCT kitap_bask.KitapID) AS BenzersizKitapSayisi,
    yay.YayineviAdi as 'Yayınevi Adı'
FROM KitapBaskilari kitap_bask
INNER JOIN Yayinevleri yay ON yay.YayineviID=kitap_bask.YayineviID
GROUP BY yay.YayineviID,yay.YayineviAdi;



--Ortalama baskı fiyatı en yüksek yayınevini bul.
CREATE VIEW max_bul_1 AS
SELECT y.YayineviID, y.YayineviAdi, AVG(kb.Fiyat) as 'Ortlama Baskı Fiyatı'
FROM Yayinevleri y
INNER JOIN KitapBaskilari kb ON y.YayineviID = kb.YayineviID
GROUP BY y.YayineviID, y.YayineviAdi;
GO

SELECT *
FROM max_bul_1
WHERE [Ortlama Baskı Fiyatı] = (SELECT MAX([Ortlama Baskı Fiyatı]) FROM max_bul_1);



--Birden fazla yayınevi tarafından basılan kitapları listele.
SELECT k.KitapID, k.KitapAdi, COUNT(DISTINCT kb.YayineviID) AS YayineviSayisi
FROM Kitaplar k
INNER JOIN KitapBaskilari kb ON k.KitapID = kb.KitapID
GROUP BY k.KitapID, k.KitapAdi
HAVING COUNT(DISTINCT kb.YayineviID) > 1;








