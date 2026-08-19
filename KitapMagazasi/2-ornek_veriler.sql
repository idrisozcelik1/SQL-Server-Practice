SELECT * FROM Kategoriler;
SELECT * FROM Kitaplar;
SELECT * FROM Musteriler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Siparisler;
SELECT * FROM Yazarlar;


-- Tüm kitapları listele.
SELECT * FROM Kitaplar;

--Yalnızca kitap adı, fiyat ve stok bilgilerini göster.
SELECT KitapAdi, Fiyat, Stok 
FROM Kitaplar;

--Fiyatı 200 TL’den yüksek kitapları getir.
SELECT * FROM Kitaplar
WHERE Fiyat>200;

--Stok miktarı 0 olan kitapları getir.
SELECT * FROM Kitaplar
WHERE Stok=0;

--Fiyatı 100 ile 300 TL arasındaki kitapları getir.
SELECT * FROM Kitaplar 
WHERE Fiyat BETWEEN 100 AND 300;

--Belirli bir şehirde yaşayan müşterileri getir.
SELECT Sehir From Musteriler 
WHERE Sehir='Bursa';

--Durumu Tamamlandı olan siparişleri getir.
SELECT * FROM Siparisler
WHERE Durum='Tamamlandı';

--Kitapları fiyatına göre küçükten büyüğe sırala.
SELECT KitapAdi as 'Kitap Adı', Fiyat FROM Kitaplar
ORDER BY fİYAT asc;

--Kitapları yayın tarihine göre yeniden eskiye sırala.
SELECT KitapAdi as 'Kitap Adı', YayinTarihi as 'Yayın Tarihi' FROM Kitaplar
ORDER BY YayinTarihi desc;

--İlk beş kitabı getir.
SELECT TOP 5 * FROM Kitaplar;

--Müşterilerin bulunduğu şehirleri tekrarsız listele.
SELECT DISTINCT Sehir FROM Musteriler;

--Adında “SQL” kelimesi geçen kitapları bul.
SELECT KitapAdi AS 'Kitap Adı' 
FROM Kitaplar 
WHERE KitapAdi LIKE '%SQL';



