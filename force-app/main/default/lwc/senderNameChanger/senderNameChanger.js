import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Id from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import SenderNameFIELD from '@salesforce/schema/User.SenderName';
import saveSenderName from '@salesforce/apex/EmailSettingsController.saveSenderName';

export default class SenderNameChanger extends LightningElement {

    loading = false;
    newSenderName = '';
    currentSenderName;

    @wire(getRecord, { recordId: Id, fields: [SenderNameFIELD]}) 
    currentUserInfo({error, data}) {
        if (data) {
            this.currentSenderName = data.fields.SenderName.value;
        } else if (error) {
            console.log(error);
        }
    }

    handleChangeSenderName(event){
        this.newSenderName = event.target.value;
    }

    handleSaveSenderName(){
        this.loading = true;

        saveSenderName({ newSenderName: this.newSenderName})
            .then(result => {
                const toastEvent = new ShowToastEvent({
                    title: 'Success',
                    variant: 'success',
                    message: 'Outgoing name changed successfully',
                });
                this.dispatchEvent(toastEvent);

                this.currentSenderName = this.newSenderName;
                this.newSenderName = '';
                
                this.loading = false;
            })
            .catch(error => {
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'error',
                    message: 'Erreur when trying to change the outgoing name',
                });
                this.dispatchEvent(event);
                this.loading = false;
            });
    }
}