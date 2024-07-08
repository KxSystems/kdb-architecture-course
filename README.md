# kdb+ Architecture

This repo contains sample kdb+ architecture for building a kdb+ application for capturing real time streaming data. This repo accompanies the online training course on the [KX Academy](https://learninghub.kx.com/courses/kdb-architecture/). 

## Prerequisites

- If you run this application using the free sandbox provided on the KX Academy - then there are no prerequisites needed.
- If you clone this repository to your local environment, you will need to have kdb+ installed with a valid license and the `q` alias set to invoke kdb+ as per [these instructions](https://code.kx.com/q/learn/install/#step-5-edit-your-profile).

## 1. Quickstart
```
q tick.q sym . -p 5010 
q tick/rdb.q -p 5011 
q tick/feed.q /(or run manual steps)
q tick/hdb.q sym -p 5012 
q tick/rts.q -p 5013 
q tick/gw.q -p 5014 
```

## 2. Adding Data Feed
To add a new data feed you will need to adjust two files: `sym.q` and `feed.q`.

### Add new table schema in sym.q
Define another schema for the `quote` table.
```
quote:([]time:`timespan$();sym:`g#`symbol$();bid:`float$();ask:`float$();bsize:`int$();asize:`int$());
```

### Adjust .z.ts to add a second table in feed.q

Replace:
```
.z.ts:{h_tp"(.u.upd[`trade;(2#.z.n;2?`APPL`MSFT`AMZN`GOOGL`TSLA`META;2?10000f;2?`B`S)])"};
```
With:
```
.z.ts:{h_tp"(.u.upd[`trade;(2#.z.n;2?`APPL`MSFT`AMZN`GOOGL`TSLA`META;2?10000f;2?`B`S)])";
      h_tp"(.u.upd[`quote;(2#.z.n;2?`APPL`MSFT`AMZN`GOOGL`TSLA`META;2?10000f;2?10000f;2?500i;2?500i)])"};
```       
Launch the feedhandler:
```
q tick/feed.q
```

## 3. Real Time Subscriber
```
q tick/cep.q
```

## 4. Logging & Replay 

## 5. End of Day

## 6. Gateways
Adjust `getTradeData` in gw.q.
Replace:
```
getTradeData:{[sd;ed;ids]
  hdb:h_hdb(`selectFunc;`trade;sd;ed;ids);
  rdb:h_rdb(`selectFunc;`trade;sd;ed;ids);
  :hdb.rdb }
```
With:
```
getTradeData:{[sd;ed;ids]
  hdb:h_hdb(`selectFunc;`trade;sd;ed;ids);
  rdb:h_rdb(`selectFunc;`trade;sd;ed;ids);
  :select from hdb,rdb where time = (max;time) fby([]date;sym) }
```
Launch gateway
```
q tick/gw.q -p 5014 
```
And query `getTradeData` from the gateway.
```
getTradeData[.z.D-1; .z.D;`APPL] 
```
