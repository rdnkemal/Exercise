/* 
Berikut di bawah ini adalah keseluruhan query dari "Project Data Analysis for B2B Retail: Customer Analytics Report"

Portofolio : https://sites.google.com/view/rdnkemal/home
LinkedIn   : https://www.linkedin.com/in/radenkemalnugraha-739339194/
*/

-- MEMAHAMI TABEL

-- Mengambil 5 baris pertama dari tabel orders_1
select * from orders_1 limit 5;

-- Mengambil 5 baris pertama dari tabel orders_2
select * from orders_2 limit 5;

-- Mengambil 5 baris pertama dari tabel customer
select * from customer limit 5;


-- ---------------------------------------------------------------------------


-- 1.BAGAIMANA PERTUMBUHAN PENJUALAN SAAT INI?
-- # Total Penjualan dan Revenue pada Quarter-1 (Jan, Feb, Mar) dan Quarter-2 (Apr,Mei,Jun) 

-- menghitung total penjualan dan pendapatan (revenue) dari tabel orders_1
select sum(quantity) total_penjualan,
       sum(quantity * priceeach) revenue
from orders_1;

-- menghitung total penjualan dan pendapatan (revenue) dari tabel orders_2 dengan status 'Shipped'
select sum(quantity) total_penjualan,
       sum(quantity * priceeach) revenue
from orders_2
where status = 'Shipped';


-- Menghitung persentasi keseluruhan penjualan

-- Mengambil data total penjualan dan pendapatan (revenue) dari tabel orders_1 dan orders_2, dengan menambahkan kolom "quarter" sebagai indikasi kuartal.
select quarter,
       sum(quantity) total_penjualan,
       sum(quantity * priceeach) revenue
from (select orderNumber, status, quantity, priceEach, 1 as quarter from orders_1
      union
      select orderNumber, status, quantity, priceEach, 2 as quarter from orders_2) tabel_a
where status = 'Shipped'
group by quarter;


-- Perhitungan Growth Penjualan dan Revenue
%Growth Penjualan = (6717 – 8694)/8694 = -22%

%Growth Revenue = (607548320 – 799579310)/ 799579310 = -24%


-- ---------------------------------------------------------------------------


-- 2. Apakah jumlah Customer xyz.com semakin bertambah?

-- Menghitung total customers unik yang terdaftar per quarter pada tahun 2004.
-- Kueri ini menggunakan subquery untuk mengambil tanggal pembuatan (createDate) customers antara Januari hingga Juni 2004,
-- kemudian mengelompokkan customers berdasarkan quarter untuk menghitung jumlah customers unik.
select quarter,
       count(distinct customerID) total_customers
from (select customerID, createDate, quarter(createDate) quarter 
      from customer
      where createDate between '2004-01-01' and '2004-06-30') tabel_b
group by quarter;


-- ---------------------------------------------------------------------------


-- 3. Seberapa banyak Customers tersebut yang sudah melakukan transaksi?

-- Menghitung total customers unik yang terdaftar per quarter pada tahun 2004, yang juga merupakan customers yang telah melakukan pesanan (orders) pada tabel orders_1 atau orders_2.
-- Kueri ini menggunakan subquery untuk mengambil data customers yang terdaftar antara Januari hingga Juni 2004, dan memeriksa apakah mereka ada dalam tabel orders_1 atau orders_2.
select quarter,
       count(distinct tabel_b.customerID) total_customers 
from (select c.customerID,
             c.createDate,
             quarter(c.createDate) quarter 
      from customer c
      where c.createDate between '2004-01-01' and '2004-06-30' 
            and c.customerID in (select distinct customerID from orders_1
                                  union
                                  select distinct customerID from orders_2)) tabel_b
group by tabel_b.quarter;


-- ---------------------------------------------------------------------------


-- 4. Kategori produk apa saja yang paling banyak di-order oleh Customers do Kuarter 2

-- Mengambil data kategori produk (categoryID) beserta jumlah total pesanan (total_order) dan total penjualan (total_penjualan) untuk produk yang sudah dikirim ('Shipped') dari tabel orders_2.
-- Kueri ini menggabungkan informasi tentang produk dan pesanan, mengelompokkannya berdasarkan kategori produk, dan kemudian mengurutkannya berdasarkan total pesanan secara menurun (descending).
select *
from(select categoryID, count(distinct orderNumber) as total_order, sum(quantity) as total_penjualan
     from(select left(productCode, 3) as categoryID, orderNumber, quantity
          from orders_2
          where status = 'Shipped') as tabel_c
     group by categoryID) a
order by total_order desc;


-- ---------------------------------------------------------------------------


-- 5. Seberapa banyak Customers yang tetap aktif bertransaksi setelah transaksi pertamanya?

-- Menghitung jumlah customers unik pada tabel orders_1 dan menampilkan hasilnya sebagai "total_customers".
select count(distinct customerID) as total_customers from orders_1;

-- Menghitung persentase customers yang ada dalam tabel orders_1 dan juga ada dalam tabel orders_2 untuk quarter 1 (quarter=1) dan menampilkan hasilnya sebagai "Q2".
select 1 as quarter,
       (count(distinct customerID) / 25) * 100 as Q2
from orders_1
where customerID in (select distinct customerID from orders_2);


/*

Sekian untuk Project ini. Terima kasih atas perhatiannya dan waktu yang sudah diluangkan untuk membaca. 

Have a great day! :))

*/