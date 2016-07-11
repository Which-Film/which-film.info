library all_test;

import "data_search_test.dart" as data_search_test;
import "data_service_test.dart" as data_service_test;
import "processing_test.dart" as processing_test;

main() {
  data_search_test.main();
  data_service_test.main();
  processing_test.main();
}
