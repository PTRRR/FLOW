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
        buttons[i]->draw();
    }
    
    for(int i = 0; i < texts.size(); i++){
        texts[i]->draw();
    }
    
}

void Interface::addButton(string _text, string _action, ofVec2f _position){
    
    shared_ptr<Button> newButton = shared_ptr<Button>(new Button());
    
    newButton->setFont(font);
    newButton->setText(_text);
    newButton->setAction(_action);
    newButton->setPosition(_position);
    
    buttons.push_back(newButton);
    
}

void Interface::addText(string _text, ofVec2f _position){
    
    shared_ptr<Text> newText = shared_ptr<Text>(new Text(font));
    
    newText->setText(_text);
    newText->setPosition(_position);
    
    texts.push_back(newText);
    
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

//Set

void Interface::setFont(shared_ptr<ofTrueTypeFont> _font){
    
    font = _font;
    
}