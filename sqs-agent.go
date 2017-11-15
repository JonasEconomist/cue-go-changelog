package main

import (
	"fmt"
	"io/ioutil"
	"net/http"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/sqs"
)

var (
	awsRegion = "us-east-1"
	sqsQueue  = "https://sqs.us-east-1.amazonaws.com/680545668187/test_queue"
)

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":9494", nil)
}

func handler(w http.ResponseWriter, r *http.Request) {
	payload, err := ioutil.ReadAll(r.Body)
	if err != nil {
		fmt.Println(err.Error())
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(`{"code":500,"message":"Internal Server Error"}`))
	}

	resp, err := sendSQSMessage(string(payload))
	if err != nil {
		fmt.Println(err.Error())
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(`{"code":500,"message":"Internal Server Error"}`))
	}

	json := `{"code":200,"message":"` + resp + `"}`
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(json))
}

func sendSQSMessage(message string) (string, error) {
	awsSession := session.New(&aws.Config{Region: aws.String(awsRegion)})
	svc := sqs.New(awsSession, aws.NewConfig().WithRegion(awsRegion))

	input := sqs.SendMessageInput{
		MessageBody: &message,
		QueueUrl:    &sqsQueue,
	}
	resp, err := svc.SendMessage(&input)
	if err != nil {
		fmt.Println(err.Error())
		return resp.String(), err
	}
	return resp.String(), nil
}
