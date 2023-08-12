use IceDW

--Creación del Modelo Estrella ICE
--Vista de Tabla de Hechos

CREATE TABLE DimTiempos(
IdFechaCompra int primary key not null,
DiaCompra nvarchar (15)not null,
AñoCompra nvarchar (20) not null,
FechaCompra nvarchar (20) not null,
MesCompra nvarchar (20) not null,
TrimestreCompras nvarchar (25) not null
)

create table DimEmpleados (
Id int primary key not null,
IdMunicipio int null,
PrimerNombre varchar (50) not null,
SegundoNombre varchar (50) not null,
PrimerApellido varchar (50) not null,
SegundoApellido varchar (50) not null,
Telefono char (8) null,
FechaInicio date null,
FechaFinal date null
)

create table DimMateriasPrimas (
Id int primary key not null,
Cantidad float not null,
Descripcion varchar (100) not null,
Precio float not null,
FechaInicial date null,
FechaFinal date null
)

create table DimProveedores (
Id int primary key not null,
Nombre varchar (50) not null,
Direccion varchar(50) null,
Telefono char (8) null,
FechaInicial date null,
FechaFinal date null
)

create table HechosCompras (
ID int identity (1,1) primary key not null,
IdEmpleado int foreign key references DimEmpleados(Id),
IdFechaCompra int foreign key references DimTiempos(IdFechaCompra),
IdMateriasPrimas int foreign key references DimMateriasPrimas(Id),
IdProveedor int foreign key references DimProveedores(Id),
CantidadCompras int null,
CantidadMateriaPrima nvarchar (max) null,
CostosTotales nvarchar (max) null,
GastoTotal nvarchar (max) null,
TotalDescuentos nvarchar null
)


--vista
use Ice

CREATE VIEW [dbo].[HechosCompras]
AS
Select 
c.IdCompra,
c.IdMateriaPrima,
co.IdEmpleado,
co.IdProveedor,
sum(c.Cantidad) as [Cantidad Compras],
round(sum(c.Costo * c.Cantidad * (Descuento/100)), 2) as [Total Descuentos],
Round(sum(c.Costo * c.Cantidad * (1 - Descuento/100)), 2) as [Costos Totales],
sum(c.costo) as [Gastos Totales],
sum(m.Cantidad) as [Cantidad de Materia Prima]
from Compras.DetallesCompras c
INNER JOIN Compras.Compras co
on c.IdCompra = co.Id
INNER JOIN  Inventario.MateriasPrimas m
on c.IdMateriaPrima = m.Id
group by
c.IdCompra,
c.IdMateriaPrima,
co.IdProveedor,
co.IdEmpleado
GO

Select * From [dbo].[HechosCompras]