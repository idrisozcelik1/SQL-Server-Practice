SELECT * FROM Kategoriler;
SELECT * FROM Kitaplar;
SELECT * FROM Musteriler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Siparisler;
SELECT * FROM Yazarlar;


--Bir kitabın fiyatını değiştir.
UPDATE Kitaplar SET Fiyat=215.98
WHERE YayinTarihi='2003-05-29';

--Bir kitabın stok miktarını 10 artır.
UPDATE Kitaplar SET Stok=Stok+10
WHERE KitapAdi='Sefiller';

--Belirli bir şehirdeki müşterilerin şehir bilgisini değiştir.
UPDATE Musteriler SET Sehir='Sinop'
WHERE Soyad='Aydın';

--Bir siparişin durumunu Hazırlanıyor değerinden Kargoda değerine getir.
UPDATE Siparisler SET Durum='Kargoda'
WHERE MusteriID=3;

--Önce yeni bir deneme müşterisi ekle, ardından bu müşteriyi sil.
INSERT INTO Musteriler 
VALUES ('Süleyman','Ak','test@test.com','Sakarya','2026-07-27');

--Önce yeni bir deneme müşterisi ekle, ardından bu müşteriyi sil.
DELETE FROM Musteriler 
WHERE Sehir='Sakarya';

--Var olmayan bir YazarID kullanarak kitap eklemeyi dene ve oluşan hatayı açıkla.
--Kitaplar ve Yazarlar foreign key ile YazarID üzerinden birbirine ilişkilidir. 
--99 ID'si Yazarlar tablosunda olmadığı için sistem hata verdi.
INSERT INTO Kitaplar(KitapAdi, YazarID, KategoriID, Fiyat, Stok, YayinTarihi)
VALUES('Davam',99 ,3,235.75,68,'2015-05-12'); 

--Bu da YazarID=3 e ekledik. Çünkü ID'si 3 olan bir yazar sistemde mevcut.
INSERT INTO Kitaplar(KitapAdi, YazarID, KategoriID, Fiyat, Stok, YayinTarihi)
VALUES('Davam',3 ,3,235.75,68,'2015-05-12'); 

--Siparişi bulunan bir müşteriyi silmeyi dene ve sonucu açıkla.
--Siparisler ve Musteriler MusteriID foreign key ile birbirine bağlı. Eğer müşteri silinse idi sahipsiz bir sipariş oluşacaktı.
DELETE  FROM Musteriler 
WHERE MusteriID=4;

