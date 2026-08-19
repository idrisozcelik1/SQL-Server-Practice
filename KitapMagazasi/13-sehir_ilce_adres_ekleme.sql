SELECT * FROM Kategoriler;
SELECT * FROM Kitaplar;
SELECT * FROM Musteriler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Siparisler;
SELECT * FROM Yazarlar;
SELECT * FROM Sehirler;
SELECT * FROM Ilceler;
SELECT * FROM Adresler;
SELECT * FROM MusteriAdresleri;

--SEHİR, İLÇE, ADRESLER VE MUSTERİ ADRESLERİ TABLOLARININ OLUŞTURULMASI

CREATE TABLE Sehirler(
SehirID INT PRIMARY KEY IDENTITY(1,1),
SehirAdi VARCHAR(100) NOT NULL
);

CREATE TABLE Ilceler(
IlceID INT PRIMARY KEY IDENTITY(1,1),
IlceAdi VARCHAR(100),
SehirID INT NOT NULL FOREIGN KEY REFERENCES Sehirler(SehirID)
);

CREATE TABLE Adresler(
AdresID INT PRIMARY KEY IDENTITY (1,1),
SehirID INT NOT NULL FOREIGN KEY REFERENCES Sehirler(SehirID),
IlceID INT NOT NULL FOREIGN KEY REFERENCES Ilceler(IlceID),
AdresTarifi VARCHAR(200),
AdresTuru VARCHAR(100) CHECK (AdresTuru IN('Ev','İş Yeri','Diğer'))
);

CREATE TABLE MusteriAdresleri(    --Musteriler ve Adreslerr tabloları arasındaki M:N ilişkiyi kurar. Bir müşterinin birden fazla siparişi olabilir.
MusteriAdresID INT PRIMARY KEY IDENTITY (1,1),
MusteriID INT NOT NULL FOREIGN KEY REFERENCES Musteriler(MusteriID),
AdresID INT NOT NULL FOREIGN KEY REFERENCES Adresler(AdresID)
);

ALTER TABLE Siparisler
ADD TeslimatAdresID INT NULL FOREIGN KEY REFERENCES Adresler(AdresID);


---------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM Kategoriler;
SELECT * FROM Kitaplar;
SELECT * FROM Musteriler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Siparisler;
SELECT * FROM Yazarlar;
SELECT * FROM Sehirler;
SELECT * FROM Ilceler;
SELECT * FROM Adresler;
SELECT * FROM MusteriAdresleri;

--INSERT İŞLEMLERİ
INSERT INTO Sehirler(SehirAdi) VALUES('İstanbul'),('Ankara'),('İzmir'),('Adana'),('Karabük'),('Konya'),('Samsun'),('Kırşehir'),('Van'),
									 ('Kars'),('Erzurum'),('Sinop'),('Bolu'),('Kocaeli'),('Bursa'),('Kastamonu'),('Sivas'),('Muğla');


INSERT INTO Ilceler(IlceAdi,SehirID) VALUES('Tuzla',1),('Çayırova',14),('Gölbaşı',2),('Çeşme',3),('Atakum',7),('Safranbolu',5),('İnebolu',16);
									 
INSERT INTO Adresler(SehirID,IlceID,AdresTarifi,AdresTuru)
VALUES(1,1,'AWM Arkası','İş Yeri'),
(14,2,'AWM Yanı','Ev'),
(2,3,'Otopark Yanı','İş Yeri'),
(7,5,'Otopark Arkası','Diğer'),
(16,7,'Sahil Kenarı','Ev'),
(5,6,'AWM Civarı','İş Yeri');

INSERT INTO Siparisler(MusteriID,SiparisTarihi,Durum,ToplamTutar,AdresID) 
VALUES(5,'2026-08-11',2,575.0,5);

INSERT INTO Siparisler(MusteriID,SiparisTarihi,Durum,ToplamTutar,AdresID) 
VALUES(9,'2026-08-11',0,350.0,2);

INSERT INTO Siparisler(MusteriID,SiparisTarihi,Durum,ToplamTutar,AdresID) 
VALUES(1,'2026-08-12',1,245.0,3);


--Aynı müşteriye ait birden fazla adres ekle.
INSERT INTO MusteriAdresleri(MusteriID, AdresID)
VALUES(3,2),(3,1),(3,4),(6,3),(1,5),(8,6);


--Musteriler.Sehir alanını kaldır.
ALTER TABLE Musteriler
DROP COLUMN Sehir;

--Müşterilerin varsayılan adresini gösteren sorguyu yaz.
SELECT m.Ad as 'Müşteri Adı', m.Soyad as 'Müşteri Soyadı',
       mAdr.AdresID as 'Müşteri Adres ID',
	   adr.AdresTarifi as 'Adres Tarifi', adr.AdresTuru as 'Adres Türü',
	   ilce.IlceAdi as 'İlçe Adı',
	   sehir.SehirAdi as 'Şehir Adı'
FROM Musteriler m
INNER JOIN MusteriAdresleri mAdr ON m.MusteriID=mAdr.MusteriID
INNER JOIN Adresler adr ON mAdr.AdresID=adr.AdresID
INNER JOIN Ilceler ilce ON adr.IlceID=ilce.IlceID
INNER JOIN Sehirler sehir ON ilce.SehirID=sehir.SehirID;


--Şehir ve ilçeye göre sipariş sayılarını raporla.
SELECT s.SehirAdi as 'Şehir Adı', il.IlceAdi as 'İlçe Adı', COUNT(sp.SiparisID) AS ToplamSiparisSayisi
FROM Siparisler sp
INNER JOIN Adresler a ON sp.AdresID = a.AdresID
INNER JOIN Ilceler il ON a.IlceID = il.IlceID
INNER JOIN Sehirler s ON il.SehirID = s.SehirID
GROUP BY s.SehirAdi, il.IlceAdi
ORDER BY ToplamSiparisSayisi DESC;



EXEC sp_rename 'Siparisler.TeslimatAdresID', 'AdresID', 'COLUMN';


--ŞEHİR VE İLÇEYE GÖRE ADRES TÜRÜ EV OLAN SİPARİŞLERİ GETİR.
SELECT sehir.SehirAdi as 'Şehir Adı', ilce.IlceAdi as 'İlçe Adı', adr.AdresID as 'Adres ID'
FROM Ilceler ilce
INNER JOIN Sehirler sehir ON ilce.SehirID=sehir.SehirID
INNER JOIN Adresler adr ON sehir.SehirID=adr.SehirID
INNER JOIN Siparisler s ON s.AdresID=adr.AdresID
WHERE adr.AdresTuru='İş Yeri';

---------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM Kategoriler;
SELECT * FROM Kitaplar;
SELECT * FROM Musteriler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Siparisler;
SELECT * FROM Yazarlar;
SELECT * FROM Sehirler;
SELECT * FROM Ilceler;
SELECT * FROM Adresler;
SELECT * FROM MusteriAdresleri;
---------------------------------------------------------------------------------------------------------------------------------------------------------

--İLÇE VE ADRES TARİFİ GİRİLEN ONA GÖRE ARAMA YAPAN PROCEDURE YAZ.
CREATE PROCEDURE bilgi_getir
	@ilce_bilgi VARCHAR(100),
	@adres_tarifi VARCHAR(100)
AS
BEGIN
SELECT ilce.IlceAdi as 'İlçe Adı', adr.AdresTarifi as 'Adres Tarifi'
FROM Ilceler ilce 
LEFT JOIN Adresler adr ON ilce.IlceID=adr.IlceID
WHERE ilce.IlceAdi=@ilce_bilgi AND adr.AdresTarifi=@adres_tarifi;
END

EXEC bilgi_getir1
	@ilce_bilgi='Gölbaşı',
	@adres_tarifi='AWM Arkası';



CREATE PROCEDURE bilgi_getir1
	@ilce_bilgi VARCHAR(100),
	@adres_tarifi VARCHAR(100)
AS
BEGIN
SELECT ilce.IlceAdi as 'İlçe Adı', adr.AdresTarifi as 'Adres Tarifi'
FROM Ilceler ilce 
LEFT JOIN Adresler adr ON ilce.IlceID=adr.IlceID
WHERE ilce.IlceAdi=@ilce_bilgi OR adr.AdresTarifi=@adres_tarifi;
END

EXEC bilgi_getir1
	@ilce_bilgi='Gölbaşı',
	@adres_tarifi='AWM Arkası';


---------------------------------------------------------------------------------------------------------------------------------------------------------
--DIŞARIDAN GİRİLEN MÜŞTERİ ADI,SOYADI, ADRES TÜRÜ, ŞEHİR ADINA GÖRE PROCEDURE YAZ.
CREATE PROCEDURE bilgi_getir2
	@musteri_adi VARCHAR(100),
	@musteri_soyadi VARCHAR(100),
	@adres_turu VARCHAR(100),
	@sehir_adi VARCHAR(100)
AS
BEGIN

SELECT m.Ad as 'Müşteri Adı', m.Soyad as 'Müşteri Soyadı', adr.AdresTuru as 'Adres Türü', sehir.SehirAdi as 'Şehir Adı'
FROM Adresler adr 
INNER JOIN Sehirler sehir ON adr.SehirID=sehir.SehirID
INNER JOIN MusteriAdresleri mAdr ON mAdr.AdresID=adr.AdresID
INNER JOIN Musteriler m ON m.MusteriID=mAdr.MusteriID
WHERE m.ad=@musteri_adi AND m.Soyad=@musteri_soyadi AND adr.AdresTuru=@adres_turu AND sehir.SehirAdi=@sehir_adi;
END

EXEC bilgi_getir2
	@musteri_adi='Barış',
	@musteri_soyadi='Ugurtay',
	@adres_turu='Ev',
	@sehir_adi='Ankara';


---------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE bilgi_getir3
	@musteri_adi VARCHAR(100),
	@musteri_soyadi VARCHAR(100),
	@adres_turu VARCHAR(100),
	@sehir_adi VARCHAR(100)
AS
BEGIN

SELECT m.Ad as 'Müşteri Adı', m.Soyad as 'Müşteri Soyadı', adr.AdresTuru as 'Adres Türü', sehir.SehirAdi as 'Şehir Adı'
FROM Adresler adr 
INNER JOIN Sehirler sehir ON adr.SehirID=sehir.SehirID
INNER JOIN MusteriAdresleri mAdr ON mAdr.AdresID=adr.AdresID
INNER JOIN Musteriler m ON m.MusteriID=mAdr.MusteriID
WHERE m.ad=@musteri_adi OR m.Soyad=@musteri_soyadi OR adr.AdresTuru=@adres_turu OR sehir.SehirAdi=@sehir_adi;
END

EXEC bilgi_getir3
	@musteri_adi='Barış',
	@musteri_soyadi='Ugurtay',
	@adres_turu='Ev',
	@sehir_adi='Ankara';


---------------------------------------------------------------------------------------------------------------------------------------------------------


