1- Kullanılan veritabanı sistemi
Microsoft SQL Server (MSSQL), Microsoft tarafından geliştirilen güçlü bir ilişkisel veritabanı yönetim sistemidir. 
Büyük ve küçük ölçekli kurumsal uygulamaların verilerini güvenli, hızlı ve düzenli bir şekilde depolamasını, yönetmesini ve sorgulamasını sağlar.
İletişim için Microsoft'a özgü T-SQL (Transact-SQL) dilini kullanır.


2- Projenin kısa açıklaması
Bu proje bir Kitap Mağazası veritabanı tasarımı ve yönetimidir. 
Sistem; kitapların kategorilerine ve yazarlarına göre katmanlı yönetimini, müşterilerin sistem üzerindeki kaydolma süreçlerini ve 
bu müşterilerin verdikleri siparişlerin sipariş detayları ile birlikte stok, tutar ve durum takibini ilişkisel bir yapıda gerçekleştirmektedir.

Sistem üzerinde gelişmiş SQL sorguları (JOIN, GROUP BY, Subquery), veri manipülasyonları (DML), 
iş mantığını yöneten Saklı Prosedürler (Stored Procedure) ve otomatik stok takibi sağlayan Tetikleyiciler (Trigger) aktif olarak kullanılmıştır.


3- Tablolar ve aralarındaki ilişkiler
Kategoriler(1) -> Kitaplar(N) : Bire çok ilişki(1-N), bir kategoride birden fazla kitap bulunabilir, ancak bir kitap tek bir kategoriye aittir.
Yazarlar(1) -> Kitaplar(N): Bire-Çok (1:N) ilişki. Bir yazar birden fazla kitap yazabilir, ancak bir kitap tek bir yazara bağlıdır.
Musteriler(1) -> Siparisler(N): Bire-Çok (1:N) ilişki. Bir müşteri birden fazla sipariş verebilir.
Siparisler(1) -> SiparisDetaylari(N): Bire-Çok (1:N) ilişki. Bir siparişin içerisinde birden fazla sipariş kalemi/satırı yer alabilir.
Kitaplar(1) -> SipraisDetaylari(N): Bire-Çok (1:N) ilişki. Bir kitap farklı siparişlerin detaylarında defalarca satılabilir.

**Siparisler ve Kitaplar tabloları, SiparisDetay tablosu üzerinden Çoka-Çok (M:N) ilişki kurmuş olur. 2li joın kurulması gerekmektedir.



4- Primary Key ve Foreign Key açıklaması
Her tabloda 1'er adet Primary Key bulunmaktadır ve IDENTITY şekilde tanımlanmıştır ki
her yeni bir kayıt da ID'si birer birer artsın. Her yeni bir kayıtın benzersiz olması sağlanmıştır.
Tabolarda JOIN uygulamaları gerçekleştirebilmek için FOREIGN KEY atamaları yapılmıştır. Tablolar arasındaki ilişki bu keyler üzerinden yapılmaktadır.



5-Projenin nasıl çalıştırılacağı
SQL Server Management Studio'yu (SSMS) Açın:
Programı çalıştırın ve sunucunuza bağlanın (Connect).

Geri Yükleme Penceresini Açın:
Sol tarafta yer alan Nesne Gezgini (Object Explorer) panelindeki Veritabanları (Databases) klasörüne sağ tıklayın:

SSMS: Restore Database... seçeneğine tıklayın.

Yedek (.bak) Dosyasını Seçin:

Açılan ekranda Kaynak (Source) başlığı altındaki Aygıt (Device) radyo düğmesini işaretleyin.

Sağ taraftaki ... (Gözat) butonuna tıklayın.

Açılan pencerede Ekle (Add) butonuna basarak bilgisayarınıza indirdiğiniz .bak dosyasını bulun, 
seçin ve Tamam (OK) butonuna tıklayın.

Kurulumu Tamamlayın:

Ana ekrana döndüğünüzde pencerenin alt kısmındaki listede veritabanı yedeğinin seçili (tik işaretli) olduğunu doğrulayın.

Sayfanın altındaki Tamam (OK) butonuna basarak yüklemeyi başlatın.

Ekrana "Veritabanı başarıyla geri yüklendi" (Database restored successfully) bildirimi geldiğinde tüm tablolar, 
veriler, ilişkiler ve kodlar veritabanınıza eksiksiz yüklenmiş olacaktır.


6-Öğrencinin en çok zorlandığı üç konu
1.konu GROUP BY konusudur.
2.konu SUBQUERY konusudur.
3.konu Trigger konusudur.