//
//  Interface.mm
//  ofMagnet
//
//  Created by Pietro Alberti on 16.12.16.
//
//

#include "Interface.h"

Interface::Interface(){};

Interface::Interface(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    
}

void Interface::draw(){

    for(int i = 0; i < buttons.size(); i++){
        
        ofVec2f buttonOriginalPosition = buttons[i]->getPosition();
        
        buttons[i]->setPosition(buttonOriginalPosition + getPosition());
        buttons[i]->draw();
        buttons[i]->setPosition(buttonOriginalPosition);
        
    }
    
    for(int i = 0; i < texts.size(); i++){
        
        ofVec2f textOriginalPosition = texts[i]->getPosition();
        
        texts[i]->setPosition(textOriginalPosition + getPosition());
        texts[i]->draw();
        texts[i]->setPosition(textOriginalPosition);
        
    }
    
}

shared_ptr<Button> Interface::addButton(string _text, string _action, ofVec2f _position){
    
    shared_ptr<Button> newButton = shared_ptr<Button>(new Button());
    
    newButton->setFont(font);
    newButton->setText(_text);
    newButton->setAction(_action);
    newButton->setPosition(_position);
    
    buttons.push_back(newButton);

    return newButton;
    
}

shared_ptr<Text> Interface::addText(string _text, ofVec2f _position){
    
    shared_ptr<Text> newText = shared_ptr<Text>(new Text(font));
    
    newText->setText(_text);
    newText->setPosition(_position);
    
    texts.push_back(newText);
    
    return newText;
    
}

void Interface::removeButton(shared_ptr<Button> _button){
    
    for(int i = 0; i < buttons.size(); i++){
        
        if(buttons[i] == _button){
            
            buttons.erase(buttons.begin() + i);
            break;
            
        }
        
    }
    
}

//Inputs

void Interface::mouseDown(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    for(int i = 0; i < buttons.size(); i++){
        if (buttons[i]->isOver(_position)) {
            callback(buttons[i]->getText(), buttons[i]->getAction());
            break;
        }
    }
    
}

void Interface::mouseMove(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    for(int i = 0; i < buttons.size(); i++){
        if (buttons[i]->isOver(_position)) {
            callback(buttons[i]->getText(), buttons[i]->getAction());
            break;
        }
    }
    
}

void Interface::mouseDrag(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    for(int i = 0; i < buttons.size(); i++){
        if (buttons[i]->isOver(_position)) {
            callback(buttons[i]->getText(), buttons[i]->getAction());
            break;
        }
    }
    
}

void Interface::mouseUp(ofVec2f _position, function<void(string _text, string _action)> callback){
    
    for(int i = 0; i < buttons.size(); i++){
        if (buttons[i]->isOver(_position)) {
            callback(buttons[i]->getText(), buttons[i]->getAction());
            break;
        }
    }
    
}

//Get

shared_ptr<Button> Interface::getButton(string _text){
    
    for(int i = 0; i < buttons.size(); i++){
        
        if(_text == buttons[i]->getText()){
            return buttons[i];
            break;
        }
        
    }
    
    return nullptr;
    
}

vector<shared_ptr<Button>> Interface::getButtons(){
    
    return buttons;
    
}

//Set

void Interface::setFont(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    
}

void Interface::setPosition(ofVec2f _position){
    
    Interface::BaseElement::setPosition(_position);
    
    for(int i = 0; i < buttons.size(); i++){
        
    }
    
}
