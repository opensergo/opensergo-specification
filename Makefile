api:
	mkdir -p build/java/ build/go/
	protoc --proto_path=. \
 	       --go_out=build/go/ \
 	       --go-grpc_out=build/go/ \
 	       --java_out=build/java/ \
	       --grpc-java_out=build/java/ \
	       specification/proto/servicecontract.proto

clean:
	rm -rf build/
