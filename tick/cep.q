/ q tick/cep.q  -p 5015
system"l tick/sym.q"

h_tp:hopen 5010;

/ initialize empty stats tables
.cep.tradeStats:([sym:`symbol$()]maxPrice:`float$();minPrice:`float$())
.cep.quoteStats:([sym:`symbol$()]maxBid:`float$();minAsk:`float$())

.cep.updTrade:{[x]
    .cep.tradeStats+:select maxPrice:max price, minPrice:min price by sym from x;
    `stats set .cep.tradeStats lj .cep.quoteStats
    }

.cep.updQuote:{[x]
    .cep.quoteStats+:select maxBid:max bid, minAsk:min ask by sym from x;
    `stats set .cep.tradeStats lj .cep.quoteStats
    }

upd:`trade`quote!(.cep.updTrade;.cep.updQuote)
h_tp"(.u.sub[`;`])";
.u.end:{}