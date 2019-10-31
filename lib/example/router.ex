defmodule Example.Router do
  use Plug.Router
  use Plug.ErrorHandler

  alias Example.Plug.VerifyRequest

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug VerifyRequest, fields: ["content", "mimetype"], paths: ["/upload"]
  plug :match
  plug Plug.Parsers,
    parsers: [:json],
    pass:  ["application/json"],
   json_decoder: Jason
    
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Welcome")
  end

  get "/upload" do
    send_resp(conn, 201, "Uploaded")
  end

  post "/hello" do
    IO.inspect conn.body_params # Prints JSON POST body
    send_resp(conn, 200, "Success!")
  end

  post "/bla" do
    HTTPoison.post('https://delivery-center-recruitment-ap.herokuapp.com/','{
        "externalCode": "9987071",
        "storeId": 282,
        "subTotal": "49.90",
        "deliveryFee": "5.14",
        "total": "55.04",
        "country": "BR",
        "state": "SP",
        "city": "Cidade de Testes",
        "district": "Bairro Fake",
        "street": "Rua de Testes Fake",
        "complement": "galpao",
        "latitude": -23.629037,
        "longitude":  -46.712689,
        "dtOrderCreate": "2019-06-27T19:59:08.251Z",
        "postalCode": "85045020",
        "number": "0",
        "total_shipping": 5.14,
        "items": [
            {
                "externalCode": "IT4801901403",
                "name": "Produto de Testes",
                "price": 49.9,
                "quantity": 1,
                "total": 49.9,
                "subItems": []
            }
        ],
        "payments": [
            {
                "type": "CREDIT_CARD",
                "value": 55.04
            }
        ],
        "customer": {
        	"externalCode": "136226073",
            "name": "JOHN DOE",
            "email": "john@doe.com",
            "contact": "41999999999"
        }
    }')

  end

  match _ do
    send_resp(conn, 404, "Oops!\n")
  end

  def handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    IO.inspect(kind, label: :kind)
    IO.inspect(reason, label: :reason)
    IO.inspect(stack, label: :stack)
    send_resp(conn, conn.status, "Something went wrong")
  end
end