SELECT * FROM Kategoriler;
SELECT * FROM Kitaplar;
SELECT * FROM Musteriler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Siparisler;
SELECT * FROM Yazarlar;

INSERT INTO Kategoriler(KategoriAdi,Aciklama)
VALUES('Hitabet(Söylev)','Halka Söyleşi');

INSERT INTO Yazarlar(Ad,Soyad,Ulke,DogumTarihi)
VALUES ('Mustafa Kemal','Atatürk','Yunanistan','1881-03-05'),
	   ('Peyami','Safa','Türkiye','1941-01-09'),
	   ('Franz','Kafka','Almanya','1861-02-05');


INSERT INTO Kitaplar(KitapAdi,YazarID,KategoriID,Fiyat,Stok,YayinTarihi)
VALUES('Nutuk',9,6,360.0,15,'1925-12-12');


--TRANSACTION: KODA HATALI VERİLER GİRMEMEK İÇİN GEÇİCİ HAZFIZA YÖNTEMİ.
BEGIN TRAN; --başlangıç kodu

UPDATE Kitaplar SET Fiyat=Fiyat+25 WHERE Stok=15;

SELECT * FROM Kitaplar;

COMMIT TRAN; --Eğer işlemler doğru ise onaylarsın.
ROLLBACK TRAN; --Eğer işlemler hatalı ise işlemi geri almak için kullanılır.




INSERT INTO Yazarlar(Ad,Soyad,Ulke,DogumTarihi)
VALUES('Anonim','Anonim','Belirsiz','1453-01-01');




BEGIN TRAN;
INSERT INTO Kitaplar(KitapAdi,YazarID,KategoriID,Fiyat,Stok,YayinTarihi)
VALUES ('Kırmızı Başlıklı Kız',15,5,120.0,155,'1367-12-12');

SELECT * FROM Kitaplar;

COMMIT TRAN;
ROLLBACK TRAN;

