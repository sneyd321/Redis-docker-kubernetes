import redis, json


     
r = redis.Redis(host="127.0.0.1", port=6379, password="")

test_data = open(r"./Capture.PNG", mode="rb")
#leaseData = json.load(test_data)

r.set("test", str(test_data.read()))

#print(r.get("test"))
        
