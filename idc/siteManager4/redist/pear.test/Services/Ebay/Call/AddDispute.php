<?PHP
/**
 * Add a dispute
 *
 * $Id: AddDispute.php,v 1.2 2004/12/23 15:21:05 schst Exp $
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/AddDispute/AddDisputeLogic.htm
 */
class Services_Ebay_Call_AddDispute extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'AddDispute';

   /**
    * compatibility level this method was introduced
    *
    * @var  integer
    */
    protected $since = 361;
    
   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'ItemId',
                                 'TransactionId',
                                 'DisputeReason',
                                 'DisputeExplanation'
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
        if ($return['CallStatus'] === 'Success') {
        	return $return['DisputeId'];
        }
        return false;
    }
}
?>