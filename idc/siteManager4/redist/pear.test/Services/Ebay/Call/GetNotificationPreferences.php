<?PHP
/**
 * Get the notification preferences
 *
 * $Id: GetNotificationPreferences.php,v 1.1 2004/10/28 17:14:53 schst Exp $
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetNotificationPreferences/GetNotificationPreferencesLogic.htm
 */
class Services_Ebay_Call_GetNotificationPreferences extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetNotificationPreferences';

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'Role'
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
        return $return['Preferences'];
    }
}
?>