SELECT * FROM Kategoriler;
SELECT * FROM Musteriler;
SELECT * FROM SiparisDetaylari;
SELECT * FROM Siparisler;
SELECT * FROM Yazarlar;
SELECT * FROM Kitaplar;

SELECT AVG(Fiyat) FROM Kitaplar;

--Ortalama fiyattan pahalı kitapları getir.
SELECT KitapAdi as 'Kitap Adı'
FROM Kitaplar
WHERE Fiyat > (SELECT AVG(Fiyat) FROM Kitaplar)


--En pahalı kitabı veya kitapları getir.
SELECT KitapID, KitapAdi, Fiyat
FROM Kitaplar
WHERE Fiyat = (SELECT MAX(Fiyat) FROM Kitaplar);


--En fazla sipariş tutarına sahip müşteriyi bul.
SELECT TOP 1 MusteriID, ToplamTutar
FROM (SELECT MusteriID, SUM(ToplamTutar) AS ToplamTutar
FROM Siparisler
GROUP BY MusteriID) AS MusteriToplamlari
ORDER BY ToplamTutar DESC;


SELECT TOP 1 m.MusteriID, m.Ad, m.Soyad, SUM(s.ToplamTutar) AS ToplamTutar
FROM Musteriler m
INNER JOIN Siparisler s ON m.MusteriID = s.MusteriID
GROUP BY m.MusteriID, m.Ad, m.Soyad
ORDER BY ToplamTutar DESC;





--Hiç sipariş vermeyen müşterileri alt sorguyla getir.
SELECT m.Ad as 'Müşteri Adı', m.Soyad as 'Müşteri Soyadı', m.MusteriID
FROM Musteriler m
LEFT JOIN Siparisler s ON m.MusteriID=s.MusteriID
WHERE m.MusteriID NOT IN (SELECT DISTINCT s.MusteriID 
FROM Siparisler s
WHERE s.MusteriID IS NOT NULL);



--En fazla kitaba sahip yazarı bul.
SELECT Ad, Soyad
FROM Yazarlar
WHERE YazarID = (SELECT TOP 1 YazarID FROM Kitaplar
GROUP BY YazarID
ORDER BY COUNT(KitapID) DESC
);


--Kendi kategorisinin ortalama fiyatından daha pahalı kitapları bul.
SELECT k.KitapID, k.KitapAdi, k.KategoriID, ktg.KategoriAdi, k.Fiyat
FROM Kitaplar k
INNER JOIN Kategoriler ktg ON k.KategoriID = ktg.KategoriID

WHERE k.Fiyat > (
    SELECT AVG(k2.Fiyat)
    FROM Kitaplar k2
    WHERE k2.KategoriID = k.KategoriID
    
);
