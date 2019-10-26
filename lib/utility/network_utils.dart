enum Status { LOADING, COMPLETED, ERROR, HALT }

class ApiResponse<T> {
    Status status;
    T data;
    String message;

    ApiResponse.loading({this.message}) : status = Status.LOADING;
    ApiResponse.completed(this.data) : status = Status.COMPLETED;
    ApiResponse.error(this.message) : status = Status.ERROR;
    ApiResponse.halt() : status = Status.HALT;

    @override
    String toString() {
        return "Status : $status \n Message : $message \n Data : $data";
    }
}

const STATUS = 'status';
const ERROR = 'error';
const SUCCESS = 'success';