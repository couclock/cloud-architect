import json
import yfinance as yf

def handler(event, context):

    print(f"Event recu: {event}")

    pathParameters = event.get("pathParameters", {})
    queryStringParameters = event.get("queryStringParameters", {})

    action = pathParameters.get("action", "current-price")
    ticker_symbol = pathParameters.get("ticker", "AAPL")
    ticker = yf.Ticker(ticker_symbol)
    
    try:
    
        if action == "current-price":
            result = {"ticker": ticker_symbol, "action": action, "data": ticker.fast_info.last_price}

        elif action == "price-history":

            data = ticker.history(
                start=queryStringParameters.get("start_date", "2025-01-01"), 
                end=queryStringParameters.get("end_date", "2025-01-31"))
            result = {"ticker": ticker_symbol, "action": action, "data": data.reset_index().to_dict(orient="records")}

        elif action == "info":
            result = {"ticker": ticker_symbol, "action": action, "data": ticker.info}

        elif action == "dividends":
            data = ticker.get_dividends()
            dividends_dict = {
                idx.isoformat(): float(value)
                for idx, value in data.items()
            }
            result = {"ticker": ticker_symbol, "action": action, "data": dividends_dict}

        elif action == "analyst-price-targets":
            result = {"ticker": ticker_symbol, "action": action, "data": ticker.get_analyst_price_targets()}

        elif action == "balance-sheet":
            data = ticker.get_balance_sheet(freq=queryStringParameters.get("frequency", "yearly")) # Report frequency: yearly, quarterly or trailing
            data.rename(inplace=True, columns= lambda s: s.strftime("%Y-%m-%d"))
            data = data.replace({float('nan'): None})
            result = {"ticker": ticker_symbol, "action": action, "data": data.to_dict(orient="dict")}

        elif action == "income-statement":
            data = ticker.get_income_stmt(freq=queryStringParameters.get("frequency", "yearly")) # Report frequency: yearly, quarterly or trailing
            data.rename(inplace=True, columns= lambda s: s.strftime("%Y-%m-%d"))
            data = data.replace({float('nan'): None})
            result = {"ticker": ticker_symbol, "action": action, "data": data.to_dict(orient="dict")}

        elif action == "cash-flow":
            data = ticker.get_cashflow(freq=queryStringParameters.get("frequency", "yearly")) # Report frequency: yearly, quarterly or trailing
            data.rename(inplace=True, columns= lambda s: s.strftime("%Y-%m-%d"))
            data = data.replace({float('nan'): None})
            result = {"ticker": ticker_symbol, "action": action, "data": data.to_dict(orient="dict")}

        elif action == "search":
            query = queryStringParameters.get("query", "")
            typeParam = queryStringParameters.get("type", "all") # stock, etf, mutualfund

            qRes = yf.Lookup(query)
            if typeParam == 'stock':
                data = qRes.get_stock()
            elif typeParam == 'etf':
                data = qRes.get_etf()
            elif typeParam == 'mutualfund':
                data = qRes.get_mutualfund()
            else:
                data = qRes.get_all()
            data = data.replace({float('nan'): None})
            data.reset_index(inplace=True)

            result = {"action": action, "data": data.to_dict(orient="records")}

        else:
            result = {"ticker": ticker_symbol, "error": f"Action inconnue: {action}"}

    except Exception as e:
        last_close = None
        print(f"Erreur lors de l'action {action} sur {ticker_symbol}: {e}")

    # Affichage dans les logs CloudWatch
    print(f"[{action}] exécutée pour {ticker_symbol}")

    # Retour JSON
    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(result, default=str)  # default=str pour sérialiser les objets non JSON
    }
