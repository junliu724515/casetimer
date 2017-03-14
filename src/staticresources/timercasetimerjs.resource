// timercasetimer.js

var jq = jQuery.noConflict();

var recordId;

var isClosedCase;

var isLoggedOut = false;

var isTimeSaved = false;

jq(function(){

    recordId = jq('#recordId').val().slice(0, -3);
    isClosedCase = (jq('#isClosedCase').val() == 'true');
    //initialize the storage object to cache time, state and tab id etc
    if (sessionStorage.getItem(recordId)==null) {
        sessionStorage.setItem(recordId, JSON.stringify({}));
    }

    jq('#play').hide();
    jq('#divId').attr('class','ticking slds-input');

    var getSessionStorageValue = function(key) {
        return retrieveSessionStorageValue(recordId, key);
    }

    var setSessionStorageValue = function(key, value) {
        putSessionStorageValue(recordId, key, value);
    }

    var start = function(){
        //if the there is time stored in session, start the timer from seconds left before refresh
        //or from the hidden sidebar, see redner function in timer.js where the time is cached
        var secondsOnPage = getSessionStorageValue('secondsOnPage');
        if (secondsOnPage) {
            jq('#divId').timer({
                recordId: recordId,
                seconds: secondsOnPage,
                editable: true,
                format: '%H:%M:%S',
            });
        }else {
            jq('#divId').timer({
                recordId: recordId,
                editable: true,
                format: '%H:%M:%S',
            });
        }
        if (!getSessionStorageValue('timerstate')){
             setSessionStorageValue('timerstate', jq('#divId').data('state'));
        }
    }

    var play = function(){
        jq('#divId').timer('resume');
        jq('#divId').attr('class','ticking slds-input');
        jq('#play').hide();
        jq('#pause').show();
        setSessionStorageValue('timerstate', jq('#divId').data('state'));
    };

    var pause = function(){
        jq('#divId').timer('pause');
        jq('#divId').attr('class','paused slds-input');
        jq('#pause').hide();
        jq('#play').show();
    };

    var manualPause = function() {
        pause();
        setSessionStorageValue('timerstate', jq('#divId').data('state'));
    }

    jq('#play').click(play);

    jq('#pause').click(manualPause);

    if (recordId) {
        //if the case is closed, no timer
        if (isClosedCase){
            jq('.timer').hide();
            //if the case is closed, save the time in the cache
            var secondsOnPage = getSessionStorageValue('secondsOnPage');
            if (secondsOnPage) {
                let eventMessage = {'recordId':recordId,'duration':secondsOnPage};
                sforce.console.fireEvent('saveEvent', JSON.stringify(eventMessage));
            }
        }
        else{
            start();
            //when refresh or hidden on the sidebar, the console will refresh the case page component
            //(destroy the old one and create a new one), and this is to keep the same state
            // from the old destroyed case page component
            if(getSessionStorageValue('timerstate')!='running'){
                pause();
            }
        }
    }
    //if the case is not saved, don't show the timer
    else{
        jq('.slds-tabs--default').hide();
    }


    var startOrPause = function(tabObjectId){
     //   let recordId = jq('#recordId').val();
    //    var recordIdWithoutSUM = jq('#recordId').val().slice(0, -3);
    //    var timerstate = sessionStorage.getItem(recordId+'state');
        if (recordId == tabObjectId && getSessionStorageValue('timerstate')!='paused' ) {
            play();
        }
        else{
            pause();
        }
    };

    var onTabClose = function (tab) {
        //check if it is logout event to avoid
        //beforeunloadevent to cache the time again
        if (tab.message=='SFORCE_CONSOLE:LOGOUT') {
            isLoggedOut = true;
        }

        if (tab.tabObjectId == recordId && !isTimeSaved) {
            var duration = jq('#divId').data('seconds');
            if (duration>0){
               //fire save event, and it's handled in getSelectedTab VF,
               //since there is an annoying quirk to save the time in this file, when closng the tab
               let eventMessage = {'recordId':recordId,'duration':duration};
               sforce.console.fireEvent('saveEvent', JSON.stringify(eventMessage));
               isTimeSaved = true;
            }
        }
    };

    var setSelectedCaseObjectId = function(result){
         let focusedTabObjectId = result.message;
         startOrPause(focusedTabObjectId);
    };

    //the event listener to hanle the fired event by swithing console primary tabs
    sforce.console.addEventListener('ObjectEvent', setSelectedCaseObjectId);
    sforce.console.addEventListener('StopEvent', function(){
        pause();
    });

    sforce.console.addEventListener(sforce.console.ConsoleEvent.CLOSE_TAB, onTabClose);
    sforce.console.addEventListener(sforce.console.ConsoleEvent.CONSOLE_LOGOUT, onTabClose);

    var openPopup = function(){

        jq('#popup').addClass('slds-fade-in-open');
        jq('#popup-backdrop').addClass('slds-modal-backdrop--open');
    };

    var closePopup = function(){

        jq('#hours').val('');
        jq('#minutes').val('');
        jq('#comments').val('');
        jq('#popup').removeClass('slds-fade-in-open');
        jq('#popup-backdrop').removeClass('slds-modal-backdrop--open');
    };

    jq('#addtime').click(function(){
        openPopup();
    });

    jq('#close, #cancel').click(function(){
        closePopup();
    });

    jq('.slds-notify-container').hide();

    var showMessage = function(message) {

        jq('.slds-notify-container').show();
        jq('#message').html(message);
        jq('.slds-notify-container').fadeOut(5000);
    };

    jq('#save').click(function(){

        var hours = jq('#hours').val();
        var minutes = jq('#minutes').val();
        var comments = jq('#comments').val();
        var caseId = jq('#recordId').val();
        var duration = hours * 3600 + minutes * 60;

        addManualTime(duration, comments);
        closePopup();
        showMessage('total time updated.');
        showManualTab();

    });

    var showAutoTab = function(){
        jq('#active-auto-icon').show();
        jq('#inactive-manual-icon').show();
        jq('#inactive-auto-icon').hide();
        jq('#active-manual-icon').hide();
        jq('#tab-default-1__item').parent().attr('class','slds-tabs--default__item slds-text-heading--label timer-tab-size slds-active');
        jq('#tab-default-2__item').parent().attr('class','slds-tabs--default__item slds-text-heading--label timer-tab-size');
        jq('#tab-default-1').attr('class','slds-tabs--default__content slds-show');
        jq('#tab-default-2').attr('class','slds-tabs--default__content slds-hide');
    };

    var showManualTab = function(){
        jq('#active-auto-icon').hide();
        jq('#inactive-manual-icon').hide();
        jq('#inactive-auto-icon').show();
        jq('#active-manual-icon').show();
        jq('#tab-default-2__item').parent().attr('class','slds-tabs--default__item slds-text-heading--label timer-tab-size slds-active');
        jq('#tab-default-1__item').parent().attr('class','slds-tabs--default__item slds-text-heading--label timer-tab-size');
        jq('#tab-default-2').attr('class','slds-tabs--default__content slds-show');
        jq('#tab-default-1').attr('class','slds-tabs--default__content slds-hide');
    };

    // show auto as the active tab
    showAutoTab();

    jq('#tab-default-1__item').click(function(){
        showAutoTab();

    });

    jq('#tab-default-2__item').click(function(){
        showManualTab();

    });

});