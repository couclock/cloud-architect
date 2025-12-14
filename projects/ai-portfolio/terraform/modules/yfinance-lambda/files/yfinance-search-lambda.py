import json
import yfinance as yf

def handler(event, context):

    print(f"Event recu: {event}")

    queryStringParameters = event.get("queryStringParameters", {})
    
    try:
    
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

        result = data.to_dict(orient="records")

    except Exception as e:
        last_close = None
        print(f"Erreur lors de l'action : {e}")

    # Retour JSON
    return {
        "statusCode": 200,
        "headers", Map.of("Content-Type", "application/json"),
        "body": json.dumps(result, default=str)  # default=str pour sérialiser les objets non JSON
    }
