class HttpException with Exception {
  String msg;

  HttpException(this.msg);

  @override
  String toString() {
    return msg;
  }
}
