/*Total de pedidos realizados em um período.*/
select sum(valor) as total 
from pedido
where data between '2025-01-11' and '2025-30-11'

/*Lanches mais vendidos.*/
select count(pl.idlanche) as quantidade, pl.idlanche, l.nomelanche 
from PedidoDetalheLanche pl
join lanche l on l.IdLanche = pl.idlanche
group by l.idlanche



/*Ingredientes mais utilizados..*/
select count(pi.idingrediente) as quantidade, pi.idingrediente, i.nomeingrediente
from PedidoDetalheIngrediente pi 
join ingrediente i on i.idingrediente = pi.idingrediente
group by i.idingrediente

/*cardápio*/
/*Cardapio master*/
select l.CodigoLanche as Codigo, l.nomelanche as Lanche, l.Valor
from lanche l
order  by l.codigolanche


/*cardapio detalhe*/
select i.nomeingrediente as Descricao
from LancheDetalheIngrediente li
join ingrediente i on i.idingrediente = li.idingrediente
group by li.IdLanche, li.idingrediente
order by li.idlanche
