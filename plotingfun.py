import matplotlib.pyplot as plt
def loss(history):
    loss=history.history['loss']
    val_loss=history.history['val_loss']
    accuracy=history.history['accuracy']
    val_accuracy=history.history['val_accuracy']
    epochs=history.epoch

    plt.figure(figsize=(10, 8))
    plt.plot(epochs,loss ,label='Training Loss')
    plt.plot(epochs,val_loss, label='Validation Loss')
    plt.title('Training and Validation Loss')
    plt.xlabel('Epochs')
    plt.ylabel('losss curve')
    plt.legend()
    plt.figure(figsize=(10,10))
    plt.plot(epochs,accuracy, label='accuracy')
    plt.plot(epochs,val_accuracy, label='val_accuracy')
    plt.title('Training and Validation Accuracy')
    plt.xlabel('Epochs')
    plt.ylabel('accuracy curve')
    plt.legend()

    import datetime
def create_tensorboard_callback(dir_name, experiment_name):
  log_dir = dir_name + "/" + experiment_name + "/" + datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
  tensorboard_callback = tf.keras.callbacks.TensorBoard(
      log_dir=log_dir
  )
  print(f"Saving TensorBoard log files to: {log_dir}")
  return tensorboard_callback




def compare_history(original_history,new_history,initial_epochs=5):
    acc=original_history.history['accuracy']
    loss=original_history.history['loss']
    val_acc=original_history.history['val_accuracy']
    val_loss=original_history.history['val_loss']
    new_acc=new_history.history['accuracy']
    new_loss=new_history.history['loss']
    new_val_acc=new_history.history['val_accuracy']
    new_val_loss=new_history.history['val_loss']
    total_acc=acc+new_acc
    total_loss=loss+new_loss
    total_val_acc=val_acc+new_val_acc
    total_val_loss=val_loss+new_val_loss
    plt.figure(figsize=(10,10))
    plt.subplot(2,1,1)
    plt.plot(total_acc,label='Training accuracy')
    plt.plot(total_val_acc,label='Validation accuracy')
    plt.plot([initial_epochs-1,initial_epochs-1],plt.ylim(),label="start Fine Tuning")
    plt.legend(loc="lower right")
    plt.subplot(2,1,2)
    plt.plot(total_loss,label='Training loss')
    plt.plot(total_val_loss,label='Validation loss')
    plt.plot([initial_epochs-1,initial_epochs-1],plt.ylim(),label="start Fine Tuning")
    plt.legend(loc="upper right")