<?php

class CitationScholarPlugin {
    public $data;
    private $cache_dir;
    private $cache_file;
    private $api_key;
    private $author_id;
    private $cache_days;

    public function __construct($namejournal, $author_id = null, $api_key = null) {
        $this->cache_dir = __DIR__ . '/cache';
        $this->cache_file = $this->cache_dir . '/stats-' . $namejournal . '.json';
        $this->api_key = $api_key ?: getenv('SERPAPI_KEY') ?: '';
        $this->author_id = $author_id ?: '';
        $this->cache_days = 30;
        
        $this->loadData();
    }

    private function loadData() {
        // Cek apakah cache tersedia dan masih valid
        if ($this->isCacheValid()) {
            $this->loadFromCache();
        } else {
            $this->fetchFromAPI();
        }
    }

    private function isCacheValid() {
        if (!file_exists($this->cache_file)) {
            return false;
        }

        $cache_data = json_decode(file_get_contents($this->cache_file), true);
        if (!$cache_data || !isset($cache_data['last_time'])) {
            return false;
        }

        $last_time = strtotime($cache_data['last_time']);
        $expire_time = strtotime("+{$this->cache_days} days", $last_time);
        
        return time() < $expire_time;
    }

    private function loadFromCache() {
        $content = file_get_contents($this->cache_file);
        $cache_data = json_decode($content);
        $this->data = $cache_data && isset($cache_data->data) ? $cache_data->data : new \stdClass();
    }

    private function fetchFromAPI() {
        if (empty($this->api_key) || empty($this->author_id)) {
            $this->data = new \stdClass();
            return;
        }

        $url = 'https://serpapi.com/search?' . http_build_query([
            'engine' => 'google_scholar_author',
            'author_id' => $this->author_id,
            'api_key' => $this->api_key
        ]);

        $ch = curl_init();
        curl_setopt_array($ch, [
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_TIMEOUT => 30,
        ]);

        $response = curl_exec($ch);
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($http_code === 200 && $response) {
            $this->saveToCache($response);
            $this->data = json_decode($response);
        } else {
            $this->data = new \stdClass();
        }
    }

    private function saveToCache($api_data) {
        if (!is_dir($this->cache_dir)) {
            mkdir($this->cache_dir, 0755, true);
        }

        $cache_data = [
            'last_time' => date('Y-m-d H:i:s'),
            'data' => json_decode($api_data)
        ];

        file_put_contents(
            $this->cache_file, 
            json_encode($cache_data, JSON_PRETTY_PRINT)
        );
    }
}

?>
