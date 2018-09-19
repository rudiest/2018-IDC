<?PHP
/**
 * Get information about a user
 *
 * $Id: GetUser.php,v 1.3 2005/01/04 22:38:23 schst Exp $
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetUser/GetUserLogic.htm
 */
class Services_Ebay_Call_GetUser extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetUser';

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'UserId',
                                 'ItemId'
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
        $user   = Services_Ebay::loadModel('User', $return['User'], $session);

        return $user;
    }
}
?>