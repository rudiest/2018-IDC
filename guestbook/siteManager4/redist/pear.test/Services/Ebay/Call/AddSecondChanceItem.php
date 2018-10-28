<?PHP
/**
 * Add a second chance for a user
 *
 * $Id: AddSecondChanceItem.php,v 1.1 2004/10/28 17:14:53 schst Exp $
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/AddSecondChanceItem/AddSecondChanceItemLogic.htm
 */
class Services_Ebay_Call_AddSecondChanceItem extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'AddSecondChanceItem';

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'OriginalItemId',
                                 'RecipientBidderUserId',
                                 'Duration',
                                 'CopyEmailToSeller',
                                 'BuyItNowPrice'
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
        return Services_Ebay::loadModel('Item', $return['Item'], $session);
    }
}
?>