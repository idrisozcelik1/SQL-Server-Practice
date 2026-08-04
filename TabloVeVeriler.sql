CREATE TABLE Yazarlar (
    YazarID INT PRIMARY KEY IDENTITY(1,1),
    Ad VARCHAR(50) NOT NULL,
    Soyad VARCHAR(50) NOT NULL,
    Ulke VARCHAR(50) NULL,
    DogumTarihi DATE NULL
);

CREATE TABLE Kategoriler(
KategoriID INT PRIMARY KEY IDENTITY(1,1),
KategoriAdi VARCHAR(50) NOT NULL UNIQUE,
Aciklama VARCHAR NULL
);

CREATE TABLE Kitaplar(
KitapID INT PRIMARY KEY IDENTITY(1,1),
KitapAdi VARCHAR(100) NOT NULL,
YazarID INT NOT NULL,
KategoriID INT NOT NULL,
Fiyat DECIMAL(10,2) CHECK (Fiyat > 0),
Stok INT CHECK (Stok >= 0),
YayinTarihi DATE NULL,


CONSTRAINT FK_Kitaplar_Yazarlar FOREIGN KEY (YazarID) REFERENCES Yazarlar(YazarID),
CONSTRAINT FK_Kitaplar_Kategoriler FOREIGN KEY (KategoriID) REFERENCES Kategoriler(KategoriID)

);

CREATE TABLE Musteriler(
MusteriID INT PRIMARY KEY IDENTITY(1,1),
Ad VARCHAR(50) NOT NULL,
Soyad VARCHAR(50) NOT NULL,
Email VARCHAR(100) NOT NULL UNIQUE,
Sehir VARCHAR(50) NULL,
KayitTarihi DATE DEFAULT GETDATE()
);

CREATE TABLE Siparisler (
    SiparisID INT PRIMARY KEY IDENTITY(1,1),
    MusteriID INT NOT NULL,
    SiparisTarihi DATETIME DEFAULT GETDATE(),
    Durum VARCHAR(20) CHECK (Durum IN ('Hazırlanıyor', 'Kargoda', 'Tamamlandı')),
    ToplamTutar DECIMAL(10,2) CHECK (ToplamTutar >= 0),

    
    CONSTRAINT FK_Siparisler_Musteriler FOREIGN KEY (MusteriID) REFERENCES Musteriler(MusteriID)
);

CREATE TABLE SiparisDetaylari (
    SiparisDetayID INT PRIMARY KEY IDENTITY(1,1),
    SiparisID INT NOT NULL FOREIGN KEY REFERENCES Siparisler(SiparisID),
    KitapID INT NOT NULL FOREIGN KEY REFERENCES Kitaplar(KitapID),
    Adet INT CHECK (Adet > 0),
    BirimFiyat DECIMAL(10,2) CHECK (BirimFiyat >= 0)
);


INSERT INTO Yazarlar (Ad, Soyad, Ulke, DogumTarihi)
VALUES 
    ('Victor', 'Hugo', 'Fransa', '1802-02-26'),        
    ('Khaled', 'Hosseini', 'Afganistan', '1965-03-04'),
    ('George', 'Orwell', 'İngiltere', '1903-06-25'),    
    ('Sabahattin', 'Ali', 'Türkiye', '1907-02-25'),    
    ('Oğuz', 'Atay', 'Türkiye', '1934-10-12');         

  

    INSERT INTO Kategoriler (KategoriAdi, Aciklama)
VALUES 
    ('Roman', 'Edebi kurgu ve romanlar'),              
    ('Bilim Kurgu', 'Gelecek ve teknoloji temalı'),     
    ('Tarih', 'Geçmiş dönem incelemeleri'),           
    ('Felsefe', 'Düşünce tarihi ve mantık');          

   


    INSERT INTO Musteriler (Ad, Soyad, Email, Sehir)
VALUES 
    ('Ahmet', 'Yılmaz', 'ahmet@gmail.com', 'İstanbul'),
    ('Ayşe', 'Kaya', 'ayse@gmail.com', 'İstanbul'),
    ('Mehmet', 'Demir', 'mehmet@gmail.com', 'Ankara'),
    ('Elif', 'Çelik', 'elif@gmail.com', 'Ankara'),
    ('Can', 'Öztürk', 'can@gmail.com', 'İzmir'),
    ('Selin', 'Aydın', 'selin@gmail.com', 'Bursa');



    INSERT INTO Kitaplar (KitapAdi, YazarID, KategoriID, Fiyat, Stok, YayinTarihi)
VALUES 
    ('Sefiller', 1, 1, 210.00, 45, '1862-01-01'),
    ('Notre Dame in Kamburu', 1, 1, 180.00, 20, '1831-01-01'),
    ('Uçurtma Avcısı', 2, 1, 175.00, 60, '2003-05-29'),
    ('1984', 3, 2, 185.00, 50, '1949-06-08'),
    ('Hayvan Çiftliği', 3, 1, 120.00, 35, '1945-08-17'),
    ('Kürk Mantolu Madonna', 4, 1, 110.00, 100, '1943-01-01'),
    ('Kuyucaklı Yusuf', 4, 1, 130.00, 40, '1937-01-01'),
    ('Tutunamayanlar', 5, 1, 240.00, 25, '1972-01-01'),
    ('Tehlikeli Oyunlar', 5, 1, 195.00, 30, '1973-01-01'),
    ('Bir Bilim Adamının Romanı', 5, 1, 150.00, 0, '1975-01-01');
 

 INSERT INTO Siparisler (MusteriID, SiparisTarihi, Durum, ToplamTutar)
VALUES 
    (1, '2026-07-20 10:00:00', 'Tamamlandı', 390.00), 
    (2, '2026-07-21 11:30:00', 'Tamamlandı', 305.00),  
    (3, '2026-07-22 14:15:00', 'Hazırlanıyor', 355.00),
    (4, '2026-07-23 09:45:00', 'Kargoda', 435.00),    
    (5, '2026-07-24 16:20:00', 'Tamamlandı', 240.00),  
    (6, '2026-07-25 12:10:00', 'Hazırlanıyor', 180.00),
    (1, '2026-07-26 15:00:00', 'Kargoda', 280.00),    
    (2, '2026-07-27 08:30:00', 'Hazırlanıyor', 195.00);


    INSERT INTO SiparisDetaylari (SiparisID, KitapID, Adet, BirimFiyat)
    VALUES 
    
    (1, 1, 1, 210.00),
    (1, 2, 1, 180.00),
    (2, 3, 1, 175.00),
    (2, 7, 1, 130.00),
    (3, 4, 1, 185.00),
    (3, 3, 1, 175.00),
    (4, 8, 1, 240.00),
    (4, 6, 1, 110.00),
    (4, 5, 1, 85.00),
    (5, 8, 1, 240.00),
    (6, 2, 1, 180.00),
    (7, 1, 1, 210.00),
    (7, 6, 1, 110.00),
    (8, 9, 1, 195.00),
    (8, 10, 1, 150.00);



      SELECT * FROM Yazarlar;
      SELECT * FROM Kitaplar;
      SELECT * FROM Siparisler;
      SELECT * FROM Musteriler;
      SELECT * FROM Kategoriler;
      SELECT * FROM SiparisDetaylari;

      SELECT * FROM SiparisDetaylari WHERE SiparisID=1;