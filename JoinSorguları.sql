SELECT * FROM Kategoriler;
SELECT * FROM Musteriler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Siparisler;
SELECT * FROM Yazarlar;
SELECT * FROM Kitaplar;

INSERT INTO Yazarlar(Ad,Soyad,Ulke,DogumTarihi) VALUES('Necmettin','Erbakan','Türkiye','1935-09-03');

DELETE FROM Yazarlar WHERE YazarID=7;
UPDATE Kitaplar SET YazarID=6 WHERE KategoriID=3;

--Kitapların adını ve yazarının ad-soyad bilgisini listele.
SELECT k.KitapAdi as 'Kitap Adı', y.Ad as 'Yazar Adı', y.Soyad as 'Yazar Soyadı'
FROM Kitaplar k
LEFT JOIN Yazarlar y ON k.YazarID=y.YazarID;

--Kitap adıyla birlikte kategori adını göster.
SELECT k.KitapAdi as 'Kitap Adı', ktg.KategoriAdi as 'Kategori Adı'
FROM Kitaplar k 
LEFT JOIN Kategoriler ktg ON k.KategoriID=ktg.KategoriID;

--Kitap adı, yazar adı, kategori adı ve fiyatı tek sonuçta göster.
SELECT k.KitapAdi as 'Kitap Adı', k.Fiyat as 'Fiyatı', y.Ad as 'Yazar Adı', y.Soyad as 'Yazar Soyadı', ktg.KategoriAdi as 'Kategori Adi'
FROM Kitaplar k 
INNER JOIN Yazarlar y ON k.YazarID=y.YazarID
INNER JOIN Kategoriler ktg ON k.KategoriID=ktg.KategoriID

--Siparişleri müşteri adı ve sipariş tarihiyle listele.
SELECT m.Ad as 'Müşteri Adı', m.Soyad as 'Müşteri Soyadı', s.SiparisTarihi as 'Sipariş Tarihi'
FROM Musteriler m 
INNER JOIN Siparisler s ON m.MusteriID=s.MusteriID;

--Sipariş detaylarında kitap adı, adet ve birim fiyatı göster.
SELECT k.KitapAdi as 'Kitap Adı', k.Stok as 'Adet Sayısı', sd.BirimFiyat as 'Birim Fiyatı'
FROM Kitaplar k 
INNER JOIN SiparisDetaylari sd ON k.KitapID=sd.KitapID;

--Her sipariş için müşteri adı, kitap adı, adet ve toplam satır tutarını göster.
SELECT m.Ad as 'Müşteri Adı', m.Soyad as 'Müşteri Soyadı', k.KitapAdi as 'Kitap Adı', sd.Adet as 'Adet', (sd.Adet * sd.BirimFiyat) as 'Satır Tutarı'
FROM SiparisDetaylari sd
INNER JOIN Siparisler s ON sd.SiparisID = s.SiparisID
INNER JOIN Musteriler m ON s.MusteriID = m.MusteriID
INNER JOIN Kitaplar k ON sd.KitapID = k.KitapID
ORDER BY s.SiparisID ASC;

--Hiç kitabı olmayan yazarları listele.
SELECT y.YazarID as 'Yazar ID', y.Ad as 'Yazar Adı', y.Soyad as 'Yazar Soyadı'
FROM Yazarlar y
LEFT JOIN Kitaplar k ON y.YazarID = k.YazarID
WHERE k.KitapID IS NULL;

--Hiç sipariş vermeyen müşterileri listele.
SELECT m.Ad as 'Müşteri Adı', m.Soyad as 'Müşteri Soyadı'
FROM Musteriler m
LEFT JOIN Siparisler s ON m.MusteriID=s.MusteriID
WHERE s.SiparisID IS NULL;

--Her yazarın kitap sayısını göster. Kitabı olmayan yazarlar da sonuçta bulunsun.
SELECT y.YazarID as 'Yazar ID', y.Ad as 'Yazar Adı', y.Soyad as 'Yazar Soyadı',  COUNT(k.KitapID) AS KitapSayisi
FROM Yazarlar y
LEFT JOIN Kitaplar k ON y.YazarID = k.YazarID
GROUP BY y.YazarID, y.Ad, y.Soyad
ORDER BY KitapSayisi DESC;

--Kitabı olmayan yazar sonuçlarda yok, çünkü tüm yazarların kitabı var, şimdi yazar ekleyeceğim ama kitap eklemeyeceğim.
INSERT INTO Yazarlar (Ad,Soyad,Ulke,DogumTarihi) VALUES  ('Lev','Tolstoy','Rusya','1856-05-12');

--En çok sipariş veren müşteriyi bul.
SELECT TOP 1 m.MusteriID as 'Müşteri ID', m.Ad as 'Müşteri Adı', m.Soyad as 'Müşteri Soyadı', COUNT(s.SiparisID) as ToplamSiparisSayisi
FROM Musteriler m
INNER JOIN Siparisler s ON m.MusteriID = s.MusteriID
GROUP BY m.MusteriID, m.Ad, m.Soyad
ORDER BY ToplamSiparisSayisi DESC;
