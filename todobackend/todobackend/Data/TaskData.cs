using Microsoft.EntityFrameworkCore;
using todobackend.Models;

namespace todobackend.Data
{
    public class TaskData
    {
        private readonly AppDbContext _context;

        public TaskData(AppDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<TaskModel>> GetTasksAsync()
        {
            return await _context.Tasks.ToListAsync();
        }

        public async Task AddTaskAsync(TaskModel task)
        {
            _context.Tasks.Add(task);
            await _context.SaveChangesAsync();
        }

        public async Task SaveChangesAsync()
        {
            await _context.SaveChangesAsync();
        }

        public async Task DeleteTaskAsync(int taskId)
        {
            await _context.Tasks.Where(t => t.IdTask == taskId).ExecuteDeleteAsync();
        }

        public async Task<TaskModel> GetTaskByIdAsync(int taskId)
        {
            return await _context.Tasks.FindAsync(taskId);
        }
    }
}

