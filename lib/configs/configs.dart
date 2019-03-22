dynamic config = {};
const COMMON_CONFIG = {
    "api_server_url": "https://api.test.bitmark.com"
};

const TEST_NET_CONFIG = {
    "network": "testnet",
    "api_server_url": "https://api.test.bitmark.com",
    "apiKey": "bmk-lljpzkhqdkzmblhg"
};

const LIVE_NET_CONFIG = {
    "api_server_url": "https://api.bitmark.com"
};

configure() {
    config.addAll(COMMON_CONFIG);
    config.addAll(TEST_NET_CONFIG);
}