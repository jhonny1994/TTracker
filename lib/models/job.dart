class Job {
  final String name;
  final int rate;
  final String id;
  Job(this.name, this.rate, this.id);

  factory Job.fromMap(Map<String, dynamic> data, String id) {
    return Job(data['name'], data['rate'], id);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rate': rate,
    };
  }
}
