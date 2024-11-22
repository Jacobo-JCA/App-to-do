using global::todobackend.Data;
using global::todobackend.Models;
using Microsoft.EntityFrameworkCore;
using todobackend.ExceptionHandler;


namespace todobackend.Services
{
    public class TaskService
        {
            private readonly TaskData _taskData;

            public TaskService(TaskData taskData)
            {
                _taskData = taskData;
            }

            public async Task<IEnumerable<TaskModel>> GetAllTasks()
            {
                return await _taskData.GetTasksAsync();
            }

            public async Task CreateTask(TaskModel task)
            {
                try {
                    await _taskData.AddTaskAsync(task);
                } catch (TaskCreationException t) {
                    throw new TaskCreationException("Error al add task", t);
                }
                
            }

            public async Task<TaskModel> UpdateTaskTitleAsync(int id, string newTitle)
            {
                var task = await _taskData.GetTaskByIdAsync(id);
                if (task == null)
                {
                    throw new TaskCreationException("Task not found");
                }
                task.Title = newTitle;
                await _taskData.SaveChangesAsync();
                return task;
            }

            public async Task DeleteTaskAsync(int taskId)
            {
                var task = await _taskData.GetTaskByIdAsync(taskId);
                if (task == null)
                {
                    throw new TaskCreationException("Task not found.");
                }
                await _taskData.DeleteTaskAsync(taskId);
            }

            public async Task MarkTaskAsCompleted(int id)
            {
                   var task = await _taskData.GetTaskByIdAsync(id);
                   if (task == null)
                   {
                       throw new TaskCreationException("Task not found");
                   }
                   task.IsCompleted = true;
                   await _taskData.SaveChangesAsync();
            }

        }
}

