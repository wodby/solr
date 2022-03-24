# Search API Solr set up via config set directory

We recommend running Solr with Zookeeper (Solr Cloud mode) and uploading config sets directly from the Search API Solr Admin UI

Apart from the default config set, this image contains predefined config sets for Drupal from [Search API Solr](https://www.drupal.org/project/search_api_solr) module. To set one of the following config sets as a default for new cores, add environment variable `$SOLR_DEFAULT_CONFIG_SET` with the value `search_api_solr_[VERSION]` with `[VERSION]` replaced to one of the listed below, e.g. `search_api_solr_4.0` or `search_api_solr_8.x-3.9`.

Matrix of Search API Solr x Solr version support.

| Version  | Solr 8.x | Solr 7.x | Solr 6.x | Solr 5.x |
|----------|----------|----------|----------|----------|
| 4.1.6    | ✓        | ✓        |          |          |
| 4.0.1    | ✓        | ✓        |          |          |
| 8.x-3.9  | ✓        | ✓        | ✓        |          |
| 8.x-3.2  | ✓        | ✓        | ✓        |          |
| 8.x-2.7  |          | ✓        | ✓        |          |
| 8.x-2.6  |          | ✓        | ✓        |          |
| 8.x-2.5  |          | ✓        | ✓        |          |
| 8.x-2.4  |          | ✓        | ✓        |          |
| 8.x-2.3  |          | ✓        | ✓        |          |
| 8.x-2.2  |          | ✓        | ✓        |          |
| 8.x-2.1  |          | ✓        | ✓        |          |
| 8.x-2.0  |          | ✓        | ✓        |          |
| 8.x-1.2  |          |          | ✓        | ✓        |
| 8.x-1.1  |          |          | ✓        | ✓        |
| 8.x-1.0  |          |          | ✓        | ✓        |
| 7.x-1.14 |          | ✓        | ✓        | ✓        |
| 7.x-1.13 |          | ✓        | ✓        | ✓        |
| 7.x-1.12 |          |          | ✓        | ✓        |
| 7.x-1.11 |          |          |          | ✓        |
| 7.x-1.10 |          |          |          | ✓        |
| 7.x-1.9  |          |          |          | ✓        |
| 7.x-1.8  |          |          |          | ✓        |
| 7.x-1.7  |          |          |          | ✓        |