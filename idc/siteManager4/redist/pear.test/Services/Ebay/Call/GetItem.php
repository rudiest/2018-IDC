<?PHP
/**
 * Fetch an eBay item
 *
 * $Id: GetItem.php,v 1.2 2004/12/14 19:08:25 schst Exp $
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetItem/GetItemLogic.htm
 */
class Services_Ebay_Call_GetItem extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetItem';

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'Id',
                                 'DetailLevel',
                                 'DescFormat'
                                );
   /**
    * make the API call
    *
    * @param    object Services_Ebay_Session
    * @return   string
    */
    public function call(Services_Ebay_Session $session)
    {
        $return = parent::call($session);
        $item   = Services_Ebay::loadModel('Item', $return['Item'], $session);

        return $item;
    }
}
?>