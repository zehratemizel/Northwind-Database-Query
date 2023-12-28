--86. a.Bu ülkeler hangileri..?
select distinct country from customers
--87. En Pahalı 5 ürün
select product_name,unit_price from products
order by unit_price desc
limit  5;

--88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?
select customer_id, count(distinct(order_id)) from orders
where customer_id = 'ALFKI'
group by customer_id

--ALFKI CustomerID’sine sahip müşterim kaç ürün aldı
select customer_id, SUM(quantity) from orders o
inner join order_details od on od.order_id =o.order_id
where customer_id= 'ALFKI'
group by customer_id

--89. Ürünlerimin toplam maliyeti
select sum(unit_price*(units_in_stock + units_on_order)) from products

--90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?
select sum((unit_price*quantity)*(1-discount)) as ciro from order_details

--91. Ortalama Ürün Fiyatım
select avg(unit_price) from products

--92. En Pahalı Ürünün Adı
select product_name from products
order by unit_price desc 
limit 1

--93. En az kazandıran sipariş
--1.yol
select order_id, sum((unit_price*quantity)*(1-discount)) kazanc from order_details
group by order_id
order by kazanc asc
limit 1

--2.yol
select order_id,sum(unit_price*quantity) as dusuk_kazanc
from order_details
group by order_id
order by dusuk_kazanc asc
limit 1


--94. Müşterilerimin içinde en uzun isimli müşteri
--1.yol
select max(length(company_name)) as uzunluk, company_name from customers
group by company_name
order by uzunluk desc
limit 1

--2.yol
select company_name from customers
group by company_name
order by max(length(company_name)) desc
limit 1

--3.yol
select max(length(company_name)) AS maxuzunluk
from customers


--95. Çalışanlarımın Ad, Soyad ve Yaşları
select fiest_name, last_name,extract(year from age(current_date,birth_date)) from employees

--2.yol
select first_name, last_name, DATE_PART('year', AGE(current_date, birth_date)) as age 
from employees

--96. Hangi üründen toplam kaç adet alınmış..?
select product_id, sum(quantity) as adet from order_details
group by product_id 
order by adet desc

--2.yol
select p.product_name,sum(od.quantity) as total_quantity from products p 
inner join order_details od on p.product_id=od.product_id
group by p.product_name
order by total_quantity desc

--97. Hangi siparişte toplam ne kadar kazanmışım..?
select order_id,sum(unit_price*quantity) from order_details
group by order_id
order by order_id asc

--98. Hangi kategoride toplam kaç adet ürün bulunuyor..?
select c.category_name, sum(p.category_id) as adet from categories c
inner join products p on p.category_id = c.category_id
group by c.category_name 
order by c.category_name asc

--99. 1000 Adetten fazla satılan ürünler?
select p.product_name,sum(od.quantity) from order_details od
inner join products p on od.product_id = p.product_id
group by product_name 
having sum(od.quantity) > 1000

--100. Hangi Müşterilerim hiç sipariş vermemiş..?
select c.company_name,o.order_id from  customers c 
left join orders o on c.customer_id = o.customer_id
where o.order_id is null

--101. Hangi tedarikçi hangi ürünü sağlıyor ?
select p.product_name,s.company_name from products p
inner join suppliers s on s.supplier_id = p.supplier_id

--102. Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?
select o.order_id,s.company_name, o.shipped_date from orders o
inner join shippers s on s.shipper_id = o.ship_via

--103. Hangi siparişi hangi müşteri verir..?
select c.company_name,o.order_id from customers c
inner join orders o on c.customer_id = o.customer_id
group by c.company_name,o.order_id
order by o.order_id asc

--104. Hangi çalışan, toplam kaç sipariş almış..?
select e.first_name,e.last_name,count(order_id) as total_orders from employees e
inner join orders o on o.employee_id = e.employee_id
group by e.first_name,e.last_name
order by total_orders desc

--105. En fazla siparişi kim almış..?
select first_name,last_name,count(o.order_id)as most_ordered from employees e  
inner join orders o on e.employee_id=o.employee_id
group by first_name,last_name
order by most_ordered desc 
limit 1

--106. Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?
select o.order_id,e.first_name,e.last_name,c.company_name from orders o
inner join customers c on o.customer_id = c.customer_id
inner join employees e on o.employee_id = e.employee_id
order by order_id asc

--107. Hangi ürün, hangi kategoride bulunmaktadır..? Bu ürünü kim tedarik etmektedir..?
select p.product_name,c.category_name,s.company_name from products p
inner join categories c on c.category_id = p.category_id
inner join suppliers s  on s.supplier_id = p.supplier_id
order by product_name asc

--108. Hangi siparişi hangi müşteri vermiş, hangi çalışan almış, hangi tarihte, hangi kargo şirketi tarafından 
--gönderilmiş hangi üründen kaç adet alınmış, hangi fiyattan alınmış, ürün hangi kategorideymiş bu ürünü hangi tedarikçi sağlamış
select o.order_id,p.product_name,c.company_name,e.first_name,e.last_name,o.order_date,s.company_name,od.quantity, p.unit_price, ca.category_name
from orders o
inner join customers c on o.customer_id = c.customer_id
inner join employees e on o.employee_id = e.employee_id
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id = p.product_id
inner join categories ca on ca.category_id = p.category_id
inner join suppliers s on s.supplier_id = p.supplier_id

--109. Altında ürün bulunmayan kategoriler
select c.category_name,p.product_name from products p
left join categories c on c.category_id = p.category_id
where p.product_name is null

--110. Manager ünvanına sahip tüm müşterileri listeleyiniz.
select * from customers
where contact_title like '%Manager%'

--111. FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.
SELECT customer_id
FROM customers
WHERE customer_id LIKE 'FR___'

--112. (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.
select * from customers
where phone like '(171)%'

--113. BirimdekiMiktar alanında boxes geçen tüm ürünleri listeleyiniz. 
select * from products
where quantity_per_unit like '%boxes%'

--114. Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)
select contact_name,contact_name,contact_title,country,phone from customers
where country in ('France','Germany') and contact_title like '%Manager%'

--115. En yüksek birim fiyata sahip 10 ürünü listeleyiniz.
select product_name, unit_price from products
order by unit_price desc 
limit 10

--116. Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.
select company_name,country,city from customers
order by country asc, city asc

--117. Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.
select first_name,last_name,extract(year from age(birth_date)) from employees

--118. 35 gün içinde sevk edilmeyen satışları listeleyiniz.
select * from orders
where (shipped_date - order_date) > 35

--119. Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)
select category_name from categories 
where exists(select max(unit_price)from products)
limit 1

--2.yöntem
select category_name from categories
where exists (select max(unit_price) from products
			 where categories.category_id=products.category_id
			)
			limit 1
			
--3.yöntem			
select category_name from categories
where category_id in (select category_id from products where unit_price = 
                     (select max(unit_price) from products))
		
--120. Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)
select * from products
where exists(select category_name from categories 
			where category_name like '%on%')

--121. Konbu adlı üründen kaç adet satılmıştır.
select p.product_name,sum(od.quantity) from products p
inner join order_details od on p.product_id = od.product_id
where product_name = 'Konbu' 
group by product_name

--122. Japonyadan kaç farklı ürün tedarik edilmektedir.
select count(distinct (product_name)) from products
where exists(select * from suppliers
			 where country = 'Japan')
			 
--123. 1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücretlisi ne kadardır?
select max(freight) as maximum ,min(freight) as minimum ,avg(freight) average from orders
where extract(year from order_date )=1997

--124. Faks numarası olan tüm müşterileri listeleyiniz.
select * from customers
where fax is not null

--125. 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz. 
select* from orders
where shipped_date  between '1996-07-16' and '1996-07-30'