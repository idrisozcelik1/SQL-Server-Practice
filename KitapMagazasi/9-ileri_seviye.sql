/* Öğrenilen SQL sisteminin desteklemesine göre:
Stok miktarı sıfırın altına düşmesin diye bir trigger oluştur.
Yeni sipariş detayı eklenince stok miktarını otomatik azaltan trigger yaz. 
Müşteri numarası alan bir stored procedure yaz ve müşterinin siparişlerini döndür. (+)
Kitap numarası alan bir procedure yaz ve kitabın toplam satış miktarını göster. (+)
Kitap adı ve yazar adında arama yapan bir sorgu hazırla. (+)
Kitaplar tablosunun fiyat alanına index ekle. (+)
Index kullanımının sorgu performansına etkisini araştır. */

SELECT * FROM Kategoriler;
SELECT * FROM Kitaplar;
SELECT * FROM Musteriler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Siparisler;
SELECT * FROM Yazarlar;

--Müşteri numarası alan bir stored procedure yaz ve müşterinin siparişlerini döndür.

CREATE PROCEDURE MusteriSiparisDon
	@musteriID INT
AS
BEGIN
SELECT SiparisID as 'Siparis Numarası', MusteriID as 'Müşteri Numarası', 
	   SiparisTarihi as 'Sipariş Tarihi', Durum as 'Sipariş Durumu', ToplamTutar as 'Sipariş Toplam Tutarı'
FROM Siparisler
WHERE MusteriID=@musteriID;
END

EXEC MusteriSiparisDon
	@musteriID=1;


--Kitap numarası alan bir procedure yaz ve kitabın toplam satış miktarını göster.

CREATE PROCEDURE KitapToplamSatisGetir
	@kitapID INT
AS
BEGIN
SELECT sd.KitapID 'Kitap Numarası', SUM(sd.Adet) as 'Toplam Satış Miktarı'
FROM SiparisDetaylari sd
WHERE sd.KitapID=@kitapID
GROUP BY sd.KitapID;
END

EXEC KitapToplamSatisGetir
	@kitapID=1;


--Kitaplar tablosunun fiyat alanına index ekle.
CREATE INDEX index_fiyat
ON Kitaplar(Fiyat);

--Kitap adı ve yazar adında arama yapan bir sorgu hazırla.
CREATE PROCEDURE aramaYap
	@kitapAdi VARCHAR(200),
	@yazarAdi VARCHAR(200)
AS
BEGIN
SELECT k.KitapAdi as 'Kitap Adı', y.Ad as 'Yazar Adı', y.Soyad as 'Yazar Soyadı'
FROM Yazarlar y 
LEFT JOIN Kitaplar k ON y.YazarID=k.YazarID
WHERE k.KitapAdi LIKE '%' + @kitapAdi + '%' 
       OR y.Ad LIKE '%' + @yazarAdi + '%';
END 
GO

EXEC aramaYap
	@kitapAdi='Nutuk',
	@yazarAdi='Oğuz';



--MÜŞTERİ ADI VE SİPARİŞ DURUMUNA GÖRE ARAMA YAPAN PROCEDURE YAZ.
CREATE PROCEDURE aramaYap2
	@musteriAdi VARCHAR(200),
	@siparisDurumu INT
AS 
BEGIN
SELECT m.Ad as 'Müşteri Adı', s.Durum as 'Sipariş Durumu'
FROM Musteriler m
INNER JOIN Siparisler s ON m.MusteriID=s.MusteriID
WHERE m.Ad LIKE '%'+@musteriAdi+'%' OR s.Durum LIKE @siparisDurumu;
END 
GO

EXEC aramaYap2	
	@musteriAdi='Elif',
	@siparisDurumu=2;


DROP PROCEDURE aramaYap2;


-- YAZAR ADI, KİTAP ADI VE STOK DURUMUNA GÖRE ARAMA YAPAN PROCEDURE YAZ.

CREATE PROCEDURE aramaYap3
	@yazarAdi VARCHAR(200),
	@kitapAdi VARCHAR(200),
	@stokDurumu INT
AS
BEGIN
SELECT y.YazarAdi as 'Yazar Adı', k.KitapAdi as 'Kitap Adı', k.Stok as 'Stok Durumu'
FROM Kitaplar k
INNER JOIN Yazarlar y ON k.YazarID=y.YazarID
WHERE y.YazarAdi LIKE '%'+@yazarAdi+'%' OR k.KitapAdi LIKE '%'+@kitapAdi+'%' OR k.Stok LIKE @stokDurumu;
END
GO

EXEC aramaYap3	
	@yazarAdi='Peyami',
	@kitapAdi='1984',
	@stokDurumu=1;

-----------------------------------------------------------------------------------------------------------------------------------------

--TRIGGER
 --BİR TABLODA BİR OLAY MEYDANA GELDİĞİ ZAMAN OTOMATİK OLARAK DİĞER TABLOLARDA VS YÜRÜTÜLEN İŞLEMDİR.
 --STORED PROCEDURE'ÜN GELİŞMİŞ VERSİYONUDUR.
 --Bir TRIGGER içinde, bir transaction commit ve rollback edilemez.
 --TRIGGER MANUEL ÇAĞRILMAZ, OTOMATİK OLARAK ÇALIŞTIRILIR.


 --NEDEN KULLANILIR?
	--VERİ BÜTÜNLÜĞÜNÜ KORUMAK İÇİN KULLANILIR, BİR İŞLEM YAPILDIĞINDA İŞ KURALLARINA  GÖRE GERÇEKLEŞİP GERÇEKLEŞMEDİĞİNİ KONTROL EDİLEREK
	--HATALI GİRİŞ YAPILMASINI ÖNLER.

--AFTER TRIGGER : INSERT, UPDATE, DELETE İŞLEMLERİNDEN SONRA BELLİ İŞLEMLERİN YAPILMASI İÇİN  KULLANILIR.
--INSTEAD OF TRIGGER : BİR TABLO VEYA VIEW YAPISINDA, INSERT, UPDATE, DELETE İŞLEMLERİNİ ATLAYIP TRIGGER İÇERİSİNDEKİ İFADENİN GERÇEKLEŞTİRİLMESİ.

--TRIGGER SYTNAX
CREATE TRIGGER trigger_name
ON table_name
AFTER INSERT,UPDATE, DELETE
AS
BEGIN
	--table_name adlı tabloya 3 işlemden biri yapıldığında burada yazan kodlar otomatik olarak çalıştırılır.
END


--INSTEAD OF SYNTAX
CREATE TRIGGER trigger_name
ON table_name
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
	--table_name adlı tabloya 3 işlemden biri yapılmak istendiğinde o işlem yapılmaz, direkt bu alana yazılan kod yürütülür.
END

--INSTEAD OF BİR İŞLEMİ ENGELLEME VEYA DEĞİŞTİRME DE KULLANILIR.

--INSERTED VE DELETED : TRIGGER İÇERİSİNDE KULLANILARAK SELECT * FROM deleted DERSEK SİLİNEN KAYITLAR GELİR.





SELECT * FROM Kategoriler;
SELECT * FROM Kitaplar;
SELECT * FROM Musteriler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Siparisler;
SELECT * FROM Yazarlar;



--SİPARİŞ DETAYLARI TABLOSUNA GİRİŞ YAPILDIĞINDA KİTAPLAR TABLOSUNDAN STOK DÜŞÜREN KODU YAZ.
CREATE TRIGGER stok_dus
ON SiparisDetaylari
AFTER INSERT 
AS
BEGIN
	UPDATE k
	SET k.Stok=k.Stok-i.Adet
	FROM Kitaplar k
	INNER JOIN inserted i ON k.KitapID=i.KitapID;
END;

INSERT INTO SiparisDetaylari(SiparisID,KitapID,Adet,BirimFiyat)
VALUES(9,12,3,230.0);

--VARSAYALIM SiparisID 'si 9 olan sipariş iptal oldu, stoğun geri eklenmesi gerekmektedir.
CREATE TRIGGER stok_geri_ekle
ON SiparisDetaylari
AFTER DELETE
AS
BEGIN
	UPDATE k
	SET k.Stok=k.Stok+d.Adet
	FROM Kitaplar k 
	INNER JOIN deleted d ON k.KitapID=d.KitapID;
END;

DELETE FROM SiparisDetaylari WHERE SiparisID=9;


--Yeni sipariş detayı eklenince stok miktarını otomatik azaltan trigger yaz.
INSERT INTO Siparisler(MusteriID,SiparisTarihi,Durum,ToplamTutar)
VALUES(2,'2026-08-10',1,350.0);

CREATE TRIGGER stok_dusur
ON SiparisDetaylari
AFTER INSERT
AS
BEGIN
	UPDATE k
	SET k.Stok=K.Stok-i.Adet
	FROM Kitaplar k
	INNER JOIN inserted i ON k.KitapID=i.KitapID;
END;

INSERT INTO SiparisDetaylari(SiparisID,KitapID,Adet,BirimFiyat)
VALUES(14,12,3,230.0);


--Stok miktarı sıfırın altına düşmesin diye bir trigger oluştur.
	CREATE TRIGGER stok_kontrol
	ON SiparisDetaylari
	AFTER INSERT
	AS
	BEGIN

		IF EXISTS
		(
			SELECT 1
			FROM inserted i
			INNER JOIN Kitaplar k
			ON i.KitapID = k.KitapID
			WHERE k.Stok - i.Adet < 0
		)
		BEGIN

			RAISERROR('Stok miktarı sıfırın altına düşemez.', 16, 1);

			ROLLBACK TRANSACTION;

		END;

	END;

	--STOK MİKTARI 60'IN ÜSTÜNE ÇIKMASIN DİYE UYARI VEREN TRIGGER
	CREATE TRIGGER stok_kontrol_2
	ON SiparisDetaylari
	AFTER INSERT 
	AS
	BEGIN
	IF EXISTS(
		SELECT 1
		FROM inserted i
		INNER JOIN Kitaplar k ON i.KitapID=k.KitapID
		WHERE k.Stok-i.Adet>60
	)
	BEGIN 
		RAISERROR('Stok miktarı gereğinden fazla seviyededir.',16,2);
		ROLLBACK TRANSACTION;
		
		END;
	END;

	INSERT INTO SiparisDetaylari VALUES(3,1,5,350.0);
	INSERT INTO SiparisDetaylari VALUES(3,3,50,250.0);
		INSERT INTO SiparisDetaylari VALUES(3,5,400,250.0);







	--IF EXIST TRUE DÖNERSE ROLLBACK TRAN' A GİRER VE HATA MESAJI DÖNER.
	--EĞER FALSE DÖNERSE TRIGGER NORAML ŞEKİLDE DÖNÜŞ SAĞLAR.
--RAISERROR
0 - 10   → Bilgilendirme / mesaj
11 - 16  → Kullanıcı kaynaklı hatalar
17 - 19  → Daha ciddi sistem / kaynak problemleri
20+      → Çok ciddi hatalar

