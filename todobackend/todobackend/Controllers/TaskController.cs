using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using todobackend.Models;
using todobackend.Services;

namespace todobackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TaskController : ControllerBase
    {
        private readonly TaskService _taskService;

        public TaskController(TaskService taskService)
        {
            _taskService = taskService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<TaskModel>>> GetTasks()
        {
            var tasks = await _taskService.GetAllTasks();
            return Ok(tasks);
        }

        [HttpPost]
        public async Task<ActionResult<TaskModel>> AddTask([FromBody] TaskModel task)
        {
            await _taskService.CreateTask(task);
            return CreatedAtAction(nameof(AddTask), new { id = task.IdTask }, new { task.IdTask, task.Title, task.IsCompleted });
        }

        [HttpPut("{id}/title")]
        public async Task<ActionResult> UpdateTaskTitle(int id, [FromBody] string updatedTitle)
        {
            await _taskService.UpdateTaskTitleAsync(id, updatedTitle);
            return Ok();
        }

        [HttpDelete("{taskId}")]
        public async Task<IActionResult> DeleteTask(int taskId)
        {
            await _taskService.DeleteTaskAsync(taskId);
            return Ok(new { message = "Task deleted successfully" });
        }

        [HttpPut("{id}/complete")]
        public async Task<ActionResult> MarkTaskAsCompleted(int id)
        {
            await _taskService.MarkTaskAsCompleted(id);
            return Ok();
        }
    }
}
