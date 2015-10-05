CPPFLAGS=-g -pthread 
LDFLAGS=-g -lpthread -lcurl

INC=-I./libwebsockets/build/lib/Headers -I./include
LIB=-L./libwebsockets/build/lib

BUILD_DIR = build/
SRC_DIR = cpp/
HEAD_DIR = include/
LIB_DIR = lib/
CC_OUT = -o $(BUILD_DIR)$(notdir $@)

OBJS = $(BUILD_DIR)CSlackRTM.o $(BUILD_DIR)CWebSocket.o $(BUILD_DIR)CSlackWS.o $(BUILD_DIR)CSlackWeb.o $(BUILD_DIR)CLogging.o

all: SlackRtmTest lib

lib: $(LIB_DIR)libslackrtm.a

$(BUILD_DIR)CWebSocket.o: $(SRC_DIR)CWebSocket.cpp $(HEAD_DIR)CWebSocket.h
	g++ $(CPPFLAGS) $(INC) -c $(SRC_DIR)CWebSocket.cpp  $(CC_OUT)

$(BUILD_DIR)CSlackWeb.o: $(SRC_DIR)CSlackWeb.cpp $(HEAD_DIR)CSlackWeb.h
	g++ $(CPPFLAGS) $(INC) -c $(SRC_DIR)CSlackWeb.cpp  $(CC_OUT)
	
$(BUILD_DIR)CSlackWS.o: $(SRC_DIR)CSlackWS.cpp $(HEAD_DIR)CSlackWS.h
	g++ $(CPPFLAGS) $(INC) -c $(SRC_DIR)CSlackWS.cpp  $(CC_OUT)

$(BUILD_DIR)CLogging.o: $(SRC_DIR)CLogging.cpp $(HEAD_DIR)CLogging.h
	g++ $(INC) -Wall -c $(SRC_DIR)CLogging.cpp $(CC_OUT)

$(BUILD_DIR)CSlackRTM.o: $(SRC_DIR)CSlackRTM.cpp $(HEAD_DIR)CSlackRTM.h
	g++ $(INC) -Wall -c $(SRC_DIR)CSlackRTM.cpp $(CC_OUT)

$(BUILD_DIR)main.o: $(SRC_DIR)main.cpp
	g++ $(INC) -Wall -c $(SRC_DIR)main.cpp $(CC_OUT)

$(LIB_DIR)slackrtm.a: $(OBJS)
	ar -cvq $(LIB_DIR)slackrtm.a $(OBJS)

$(LIB_DIR)libslackrtm.a: $(LIB_DIR)slackrtm.a
	cp ./libwebsockets/build/lib/libwebsockets.a $(LIB_DIR)libslackrtm.a
	ar r $(LIB_DIR)libslackrtm.a $(OBJS)

SlackRtmTest: $(BUILD_DIR)main.o $(LIB_DIR)libslackrtm.a
	g++ $(LDFLAGS) $(LIB) -lrt -lpthread -lssl -lcrypto -lz -ljson -o SlackRtmTest $(BUILD_DIR)main.o $(LIB_DIR)libslackrtm.a

clean:
	rm -f build/*.o
	rm -f SlackRtmTest
	rm -f lib/*.a
