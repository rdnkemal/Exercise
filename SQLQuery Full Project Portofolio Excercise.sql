/*
Portfolio Exercise

Berikut adalah kueri SQL yang merangkum informasi penting tentang aktivitas penjualan di perusahaan. 

Query ini menggabungkan data dari berbagai tabel untuk memberikan gambaran yang lebih mendalam tentang
pelanggan, produk, kategori, merek, toko, dan perwakilan penjualan. 

Hasilnya mencakup detail seperti nomor pesanan, nama pelanggan, lokasi, tanggal pesanan, total unit terjual, 
pendapatan, nama produk, kategori, merek, nama toko, serta nama perwakilan penjualan.

Hasil dari kuery dibuat file excel untuk dilakukan analisis lebih lanjut, serta dibuat visualisasi di Tableau.

Berikut link terkait :
Excel : 
https://1drv.ms/x/s!AkvWvHpF4WLygxpWr8Uuk5JX-4z2?e=yrHchN

Tableau : 
https://public.tableau.com/views/BikeStoresDashboard_16933730964450/Dashboard1?:language=en-US&:display_count=n&:origin=viz_share_link

Untuk link video : https://www.youtube.com/watch?v=1pHYKdyRvrw
*/

SELECT 
	ord.order_id,
	CONCAT(cus.first_name,' ',cus.last_name) AS 'customers', -- Hanya ingin memunculkan 1 kolom nama, daripada harus membuat 2 kolom berbeda (nama depan,belakang)
	cus.city,
	cus.state,
	ord.order_date,
	SUM(ite.quantity) AS 'total_units',
	SUM(ite.quantity * ite.list_price) AS 'revenue',
	pro.product_name,
	cat.category_name,
	prb.brand_name,
	sto.store_name,
	CONCAT(sta.first_name,' ', sta.last_name) AS 'sales_rep'
FROM sales.orders ord
JOIN sales.customers cus
  ON ord.customer_id = cus.customer_id
JOIN sales.order_items ite
  ON ord.order_id = ite.order_id
JOIN production.products pro
  ON ite.product_id = pro.product_id
JOIN production.categories cat
  ON pro.category_id = cat.category_id
JOIN sales.stores sto
  ON ord.store_id = sto.store_id
JOIN sales.staffs sta
  ON ord.staff_id = sta.staff_id
JOIN production.brands prb
  ON pro.brand_id = prb.brand_id
GROUP BY
	ord.order_id,
	CONCAT(cus.first_name,' ',cus.last_name),
	cus.city,
	cus.state,
	ord.order_date,
	pro.product_name,
	cat.category_name,
	prb.brand_name,
	sto.store_name,
	CONCAT(sta.first_name,' ', sta.last_name)
