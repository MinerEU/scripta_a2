<?php
session_start();

if ( !isset($_SESSION['_logged_']) || $_SESSION['_logged_'] === false ) {
	echo json_encode(false);
	die();
}

/*
f_settings syncs settings in different files and always returns new state
returns settings and ['date']
*/
header('Content-type: application/json');
$configFolder='/opt/scripta/etc/';
$configScripta=$configFolder.'scripta.conf';
$configUipwd=$configFolder.'uipasswd';
$configOptns=$configFolder.'miner.options.json';
$configPools=$configFolder.'miner.pools.json';
$configMiner=$configFolder.'miner.conf';
$configFrequency=$configFolder.'additional_paramter';


// Set new password
if (isset($_REQUEST['pass'])) {
  $pass=json_decode($_REQUEST['pass']);
  if (strlen($pass) > 0) {
    file_put_contents($configUipwd,'scripta:' . md5($pass) );
    $r['info'][]=array('type' => 'success', 'text' => 'Web password saved');
  }
}

// Manage settings
elseif (!empty($_REQUEST['settings'])) {
  $newdata   = json_decode($_REQUEST['settings'], true);
  $r['data'] = json_decode(@file_get_contents($configScripta), true);

  // Sync current with new settings
  if(!empty($newdata)&&is_array($newdata)){
    foreach ($newdata as $key => $value) {
      $r['data'][$key]=$value;
    }
    file_put_contents($configScripta, json_encode($r['data'], JSON_PRETTY_PRINT | JSON_NUMERIC_CHECK));
    $r['info'][]=array('type' => 'success', 'text' => 'Configuration saved');
  }
  // Load current settings
  else{
    $r['info'][]=array('type' => 'info', 'text' => 'Configuration loaded');
  }

  if(isset($r['data']['userTimezone'])){
    date_default_timezone_set($r['data']['userTimezone']);
    $r['data']['date'] = date('Y-m-d H:i:s');
  }
}

// Manage pools
elseif (!empty($_REQUEST['pools'])) {
  $newdata   = json_decode($_REQUEST['pools'], true);

  $r['data'] = json_decode(@file_get_contents($configPools), true);
  if(is_array($newdata)){
      //var_dump($newdata);
      usort($newdata,'cmp');
      //var_dump($newdata);
  }else{
      usort($r['data'],'cmp');
  }
  //
  // Overwrite current with new pools
  if(!empty($newdata)&&is_array($newdata)){
    file_put_contents($configPools, json_encode($newdata, JSON_PRETTY_PRINT | JSON_NUMERIC_CHECK));

     minerConfigGenerate();

    $r['data']=$newdata;
    $r['info'][]=array('type' => 'success', 'text' => 'Pools config saved');
  }
  // Load current settings
  elseif(!empty($r['data'])&&is_array($r['data'])){
    $r['info'][]=array('type' => 'info', 'text' => 'Pools config loaded');
  }
  // Load new settings
  else{
    $r['data']=array(array('url'=>'empty'));
    $r['info'][]=array('type' => 'error', 'text' => 'Pools config not found');
  }
}

// Manage miner.conf
elseif (!empty($_REQUEST['options'])) {
  $newdata   = json_decode($_REQUEST['options'], true);
  $r['data'] = json_decode(@file_get_contents($configOptns), true);

  // Overwrite current with new config
  if(!empty($newdata)&&is_array($newdata)){
    file_put_contents($configOptns, json_encode($newdata, JSON_PRETTY_PRINT | JSON_NUMERIC_CHECK));
    minerConfigGenerate();
    $r['data']=$newdata;
    $r['info'][]=array('type' => 'success', 'text' => 'Miner options saved');
  }
  // Load current settings
  elseif(!empty($r['data'])&&is_array($r['data'])){
    $r['info'][]=array('type' => 'info', 'text' => 'Miner options loaded');
  }
  // Load new settings
  else{
    $r['data']=array(array('key'=>'algo','value'=>'c'));
    $r['info'][]=array('type' => 'error', 'text' => 'Miner options not found');
  }
}

// Set system timezone to what is stored in settings 
elseif (!empty($_REQUEST['timezone'])) {
  $timezone = json_decode($_REQUEST['timezone']);
  ini_set( 'date.timezone', $timezone );
  putenv('TZ=' . $timezone);
  date_default_timezone_set($timezone);
  $r['data']['date'] = date('Y-m-d H:i:s');
  $r['info'][]=array('type' => 'info', 'text' => 'Timezone is '.$timezone );
}

echo json_encode($r);

function minerConfigGenerate(){
  global $configOptns,$configPools,$configMiner,$configFrequency;
  $options = json_decode(@file_get_contents($configOptns), true);

  // Angular objects ==> miner
  // {key:k,value:v} ==> {k:v}
  $load_balance_flag=false;
  $additional_parameter="AdditionalParameter='";
  foreach ($options as $o) {
    $miner[$o['key']]=$o['value'];
    if(strpos($o['key'],"A1Pll")!==FALSE){
        $additional_parameter=$additional_parameter." --".$o['key']." ".$o['value'];
    }
      if(strpos($o['key'],"load-balance")!==FALSE){
          $load_balance_flag=true;
          $additional_parameter=$additional_parameter." --".$o['key']." ";
      }

  }
  $additional_parameter=$additional_parameter."' ";

    $tmp_pools = json_decode(@file_get_contents($configPools), true);

    foreach ($tmp_pools as $key => $pool) {
        if($load_balance_flag){
            $pool["quota"]=$pool["quota"].";".$pool["url"]."";
            unset($pool->url);
        } else{
            unset($pool->quota);
        }


        $new_pool=[];
        foreach ($pool as $key1 => $value) {
            if($load_balance_flag){
                if($key1=="url")continue;
            }else{
                if($key1=="quota")continue;
            }
            $new_pool[$key1]=$value;
        }

        //var_dump($new_pool);
        //}
        $tmp_pools[$key]=$new_pool;

    }
    //var_dump($tmp_pools[0]);
    $miner['pools']=$tmp_pools;
    file_put_contents($configMiner, json_encode($miner, JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES|JSON_UNESCAPED_UNICODE));
    file_put_contents($configFrequency,$additional_parameter);
    //AdditionalParameter='--A1Pll1 1200 --A1Pll2 1200 --A1Pll3 1200 --A1Pll4 1200 --A1Pll5 1200 --A1Pll6 1200'

}

function cmp($a, $b) {
    return $a["priority"] - $b["priority"];
}

?>
