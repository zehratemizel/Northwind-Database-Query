--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını 
--(`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
select p.product_id, p.product_name, s.company_name,s.phone from products p
inner join suppliers s on s.supplier_id = p.supplier_id
where units_in_stock = 0;

--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
select o.ship_address, e.first_name, e.last_name, o.order_date from orders o
inner join employees e on o.employee_id = e.employee_id
where extract(month from o.order_date)=3 and extract(year from o.order_date)=1998;


--28. 1997 yılı şubat ayında kaç siparişim var?
select count(*) from orders
where extract(month from order_date)=2 and extract(year from order_date)=1997;

--29. London şehrinden 1998 yılında kaç siparişim var?
select count(*) from orders
where ship_city = 'London' and extract(year from order_date)=1998;

--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
select c.contact_name, c.phone, o.order_date from customers c
inner join orders o on o.customer_id = c.customer_id
where extract(year from order_date)=1997;

--31. Taşıma ücreti 40 üzeri olan siparişlerim
select * from orders
where freight > 40
--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı

select o.ship_city,c.company_name,o.freight from orders o
inner join customers c on o.customer_id = c.customer_id
where freight > 40

--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
select o.order_date, o.ship_city,concat(upper (e.first_name), ' ', upper (e.last_name))
from orders o
inner join employees e on o.employee_id = e.employee_id
where extract (year from o.order_date) = 1997;

--34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
select c.contact_name, REPLACE(REPLACE(REPLACE(REPLACE(c.phone, '(', ''), ')', ''), ' ', ''),'-','')
as telefon
from customers c
inner join orders o on c.customer_id = o.customer_id
where extract(year from o.order_date) = 1997

--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
select o.order_date,c.contact_name, concat(e.first_name, ' ', e.last_name) from orders o
inner join customers c on c.customer_id = o.customer_id
inner join employees e on e.employee_id = o.employee_id 

--36. Geciken siparişlerim?
select * from orders
where shipped_date > required_date 

--37. Geciken siparişlerimin tarihi, müşterisinin adı
select c.company_name, o.order_date, o.shipped_date, o.required_date from orders o
inner join customers c on c.customer_id = o.customer_id
where shipped_date > required_date 

--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select p.product_name, c.category_name, od.quantity from products p
inner join categories c on c.category_id = p.category_id
inner join order_details od on od.product_id = p.product_id
where order_id = 10248

--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select p.product_name, s.contact_name from products p
inner join suppliers s on s.supplier_id = p.supplier_id
inner join order_details od on od.product_id = p.product_id
where order_id = 10248

--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select p.product_name, od.quantity from employees e
inner join orders o on o.employee_id = e.employee_id
inner join order_details od on od.order_id = o.order_id
inner join products p on p.product_id = od.product_id
where e.employee_id = 3 and extract (year from o.order_date)=1997

--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.employee_id,concat(e.first_name, ' ',e.last_name) as full_name,sum(od.unit_price*od.quantity) as toplam_satıs
from employees e
inner join orders o on o.employee_id = e.employee_id
inner join order_details od on od.order_id=o.order_id
where extract (year from order_date) = 1997
group by od.order_id,e.employee_id,e.first_name,e.last_name
order by toplam_satıs desc 
limit 1;

--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
select e.employee_id,e.first_name,e.last_name
from employees e
inner join orders o on e.employee_id=o.employee_id
where extract(year from o.order_date)=1997
group by e.employee_id,e.first_name,e.last_name
order by count(o.order_id) desc
limit 1;
--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name,p.unit_price,c.category_name from products p
inner join categories c on p.category_id = c.category_id
order by unit_price desc
limit 1;

--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select e.first_name, e.last_name, o.order_date, o.order_id from orders o
inner join employees e on e.employee_id = o.employee_id
order by o.order_id

--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select o.order_id, avg(unit_price) as avg_price from order_details od
inner join orders o on o.order_id = od.order_id
group by o.order_id
order by o.order_date desc
limit 5;
 
--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.product_name,c.category_name,sum(od.quantity) as total_sales from order_details od
inner join products p on od.product_id = p.product_id 
inner join categories c on c.category_id = p. category_id 
inner join orders o on o.order_id = od.order_id 
where extract(month from o.order_date)=1 
group by p.product_name, c.category_name;


--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select order_id, product_id, quantity from order_details 
where quantity > (select avg(quantity) from order_details)
group by order_id,product_id;

--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name, c.category_name, s.contact_name from order_details od
inner join products p on od.product_id = p.product_id 
inner join categories c on c.category_id = p.category_id 
inner join suppliers s on s.supplier_id= p.supplier_id
group by p.product_name, c.category_name,s.contact_name
order by sum(quantity) desc
limit 1;

--49. Kaç ülkeden müşterim var
select count(distinct(country)) from customers

--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select sum(od.quantity) from orders o
inner join order_details od on od.order_id = o.order_id
where employee_id = 3 
and date_part('year',o.order_date)>= 1998 
and date_part('month',o.order_date)>=1

--63. Hangi ülkeden kaç müşterimiz var
select distinct country, count(*) as cust_count from customers
group by country
order by country;

--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
select od.product_id,sum((od.quantity * od.unit_price)*(1-od.discount)) as ciro from order_details od
inner join orders o on o.order_id = od.order_id
where od.product_id = 10 and o.order_date >= (date '1998-05-31' -INTERVAL '3 months')
group by product_id;

--66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
select e.first_name,e.last_name, count(order_id)from employees e
inner join orders o on o.employee_id =e.employee_id
group by e.first_name,e.last_name

--2.yol
select employee_id,count(order_id) 
from orders
group by employee_id

--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
select c.company_name,o.order_id from customers c
left join orders o on c.customer_id = o.customer_id
where o.order_id is null;

--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
select company_name,contact_name,address,city,country from customers
where country = 'Brazil';

--69. Brezilya’da olmayan müşteriler
select company_name,contact_name,address,city,country from customers
where country != 'Brazil';

--70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
--1.yol
select * from customers
where country in ('Spain','France','Germany')

--2.yol
select * from customers
where country='Spain' or country='France' or country='Germany';

--71. Faks numarasını bilmediğim müşteriler
select * from customers
where fax is null;

--72. Londra’da ya da Paris’de bulunan müşterilerim
select * from customers
where city in ('London','Paris');

--73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
select * from customers
where city =('México D.F.') and contact_title='owner';

--74. C ile başlayan ürünlerimin isimleri ve fiyatları,
select product_name,unit_price from products
where product_name like 'c%';

--75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
select first_name,last_name,birth_date from employees
where first_name like 'A%';

--76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
select company_name from customers
where company_name like '%RESTAURANT%';

--77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
--1.yol
select product_name, unit_price from products
where unit_price > 50 and unit_price < 100;

--2.yol
select product_name, unit_price from products
where unit_price between 50 and 100;

--78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
select order_id, order_date from orders
where order_date between '1996-07-01' and '1996-12-31';

--81. Müşterilerimi ülkeye göre sıralıyorum:
select * from customers
order by country;

--82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name,unit_price from products
order by unit_price desc;

--83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name,unit_price,units_in_stock from products
order by units_in_stock asc, unit_price desc

--84. 1 Numaralı kategoride kaç ürün vardır..?
select p.product_name,c.category_id from products p
inner join categories c on p.category_id=c.category_id
where c.category_id=1

--85. Kaç farklı ülkeye ihracat yapıyorum..?
select count(distinct Country) from Customers