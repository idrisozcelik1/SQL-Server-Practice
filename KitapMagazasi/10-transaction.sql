SELECT * FROM Kategoriler;
SELECT * FROM Kitaplar;
SELECT * FROM Musteriler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Siparisler;
SELECT * FROM Yazarlar;

--SYTANX
BEGIN TRAN --transaction başlatmak için
*
*
*
COMMIT TRAN; --eğer işlem doğru ise
ROLLBACK TRAN; --işlemi geri almak için



--Aşağıdaki sipariş oluşturma senaryosunu transaction kullanarak gerçekleştir:
--Yeni bir sipariş oluştur.

BEGIN TRAN
INSERT INTO Siparisler(MusteriID,SiparisTarihi,Durum,ToplamTutar)
VALUES (8,'2026-10-25',2,560.0);
COMMIT TRAN;
ROLLBACK TRAN;

--Sipariş detayını ekle.
BEGIN TRAN
INSERT INTO SiparisDetaylari(SiparisID,KitapID,Adet,BirimFiyat)
VALUES (9,13,5,410);

COMMIT TRAN;
ROLLBACK TRAN;


--Satılan kitabın stok miktarını azalt.
BEGIN TRAN
UPDATE Kitaplar SET Stok=Stok-5 WHERE KitapID=13;
COMMIT TRAN;
ROLLBACK TRAN;

--Sipariş toplam tutarını hesapla.
BEGIN TRAN
SELECT SUM(Adet*BirimFiyat) as 'Toplam Tutar' FROM SiparisDetaylari WHERE SiparisDetayID=16;
COMMIT TRAN;
ROLLBACK TRAN;



--Sipariş Oluşturup Stoktan Düşme İşlemi
BEGIN TRAN
INSERT INTO Siparisler(MusteriID,SiparisTarihi,Durum,ToplamTutar)
VALUES (3,'2026-08-07',0,750.0);

INSERT INTO SiparisDetaylari(SiparisID,KitapID,Adet,BirimFiyat)
VALUES (10,4,2,185);

UPDATE Kitaplar SET Stok=Stok-2 WHERE KitapID=4;

COMMIT TRAN;
ROLLBACK TRAN;



--Bütün işlemler başarılıysa COMMIT kullan.
--İşlemlerden biri başarısız olursa ROLLBACK kullan.

--Düşünme sorusu:
--Sipariş kaydı eklenip stok azaltma işlemi başarısız olursa transaction kullanılmadığında ne gibi bir problem oluşur?

